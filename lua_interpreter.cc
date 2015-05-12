#include <time.h> // for clock_gettime
#include <locale.h> // for setlocale()
#include "lua_interpreter.h"
#include "qtdynamic.h"
#include "network.h"
#include "timers.h"
#include "qtlua.h"
#include <assert.h>
#include <iostream>
#include <stdexcept>
extern "C" {
#include <lua5.2/lua.h>
#include <lua5.2/lualib.h>
#include <lua5.2/lauxlib.h>
}
#include <QObject>
#include <QTimer>
#include <QCoreApplication>
#include <QStringList>

namespace {
int app_quit(lua_State *L) {
  lua_getglobal(L, "interp");
  LuaInterpreter *li = *static_cast<LuaInterpreter**>(lua_touserdata(L, -1));
  li->quitCalled = true;
  if (lua_isnumber(L, 1)) {
    li->retCode = lua_tointegerx(L, 1, NULL);
  }
  QCoreApplication::exit(li->retCode);
  return 0;
}

int timestamp(lua_State *L) {
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  lua_pushnumber(L, ts.tv_sec * 1000 + ts.tv_nsec / 1000000);
  return 1;
}

int arguments(lua_State *L) {
  QStringList args = QCoreApplication::instance()->arguments();
  lua_createtable(L, args.count(), 0);
  int i = 1;
  for (auto& arg : args)
  {
    lua_pushstring(L, arg.toUtf8().constData());
    lua_rawseti(L, -2, i++);
  }
  return 1;
}
}  // anonymous namespace
LuaInterpreter::LuaInterpreter(QObject *parent, const QStringList::iterator& args, const QStringList::iterator& args_end)
  : QObject(parent) {
  lua_state = luaL_newstate();

  luaL_requiref(lua_state, "base", &luaopen_base, 1);
  luaL_requiref(lua_state, "package", &luaopen_package, 1);
  luaL_requiref(lua_state, "network", &luaopen_network, 1);
  luaL_requiref(lua_state, "timers", &luaopen_timers, 1);
  luaL_requiref(lua_state, "string", &luaopen_string, 1);
  luaL_requiref(lua_state, "table", &luaopen_table, 1);
  luaL_requiref(lua_state, "debug", &luaopen_debug, 1);
  luaL_requiref(lua_state, "math", &luaopen_math, 1);
  luaL_requiref(lua_state, "io", &luaopen_io, 1);
  luaL_requiref(lua_state, "os", &luaopen_os, 1);
  luaL_requiref(lua_state, "bit32", &luaopen_bit32, 1);
  luaL_requiref(lua_state, "qt", &luaopen_qt, 1);
  // extend package.cpath
  lua_getglobal(lua_state, "package");
  assert(!lua_isnil(lua_state, -1));
  lua_pushstring(lua_state, "./modules/lib?.so;./lib?.so;");
  lua_getfield(lua_state, -2, "cpath");
  assert(!lua_isnil(lua_state, -1));
  lua_concat(lua_state, 2);
  lua_setfield(lua_state, -2, "cpath");

  lua_pushstring(lua_state, "./modules/?.lua;");
  lua_getfield(lua_state, -2, "path");
  assert(!lua_isnil(lua_state, -1));
  lua_concat(lua_state, 2);
  lua_setfield(lua_state, -2, "path");

  lua_pushcfunction(lua_state, &app_quit);
  lua_setglobal(lua_state, "quit");

  lua_pushcfunction(lua_state, &timestamp);
  lua_setglobal(lua_state, "timestamp");

  lua_pushcfunction(lua_state, &arguments);
  lua_setglobal(lua_state, "arguments");

  // Adding global 'interp'
  QObject **p = static_cast<QObject**>(lua_newuserdata(lua_state, sizeof(QObject*)));
  *p = this;
  lua_setglobal(lua_state, "interp");

  // Adding global 'argv'
  lua_createtable(lua_state, 0, 0);
  int i = 1;
  for (auto p = args; p != args_end; ++p) {
    lua_pushstring(lua_state, p->toUtf8().constData());
    lua_rawseti(lua_state, -2, i++);
  }
  lua_setglobal(lua_state, "argv");
}

int LuaInterpreter::load(const char *filename) {

  int res = luaL_dofile(lua_state, filename);
  if (res != 0) {
    std::cerr << "Lua error:" << std::endl << lua_tostring(lua_state, -1) << std::endl;
  }
  return quitCalled ? retCode : res;
}
void LuaInterpreter::quit() {
  QCoreApplication::quit();
}

LuaInterpreter::~LuaInterpreter() {
  lua_close(lua_state);
}
