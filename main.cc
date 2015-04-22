#line 5 "main.nw"
extern "C" {
#include <lua5.2/lua.h>
#include <lua5.2/lualib.h>
#include <lua5.2/lauxlib.h>
}
#line 17 "main.nw"
#include <QObject>
#include <QCoreApplication>
#include <unistd.h>
#include <assert.h>
#include <iostream>
#include <csignal>
#include <csetjmp>
#include "lua_interpreter.h"
#include <iostream>

#line 30 "main.nw"
namespace {
void abrt_handler(int signal)
{
  _exit(1);
}
}

int main(int argc, char** argv)
{
  if (argc < 2) {
    std::cerr << "Path to Lua script needed" << std::endl;
    return 1;
  }

  QCoreApplication app(argc, argv);

  LuaInterpreter lua_interpreter(&app);

  struct sigaction sa, oldsa;
  sa.sa_handler = abrt_handler;
  sigemptyset(&sa.sa_mask);
  sigaction(SIGABRT, &sa, &oldsa);
  sa.sa_flags = 0;

  int res = lua_interpreter.load(argv[1]);
  if (res) {
    return res;
  }
  if (lua_interpreter.quitCalled) {
    return lua_interpreter.retCode;
  }
  return app.exec();
}
