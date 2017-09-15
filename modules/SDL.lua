require('os')
local sdl_logger = require('sdl_logger')
local config = require('config')
local console = require('console')
local SDL = { }

require('atf.util')
--- Table of SDL build options 
SDL.buildOptions = {}
SDL.exitOnCrash = true
SDL.STOPPED = 0
SDL.RUNNING = 1
SDL.CRASH = -1

--- Structure of SDL build options what to be set
local usedBuildOptions = {
  remoteControl =  {
    sdlBuildParameter = "REMOTE_CONTROL",
    defaultValue = "ON"
  },
  extendedPolicy =  {
    sdlBuildParameter = "EXTENDED_POLICY",
    defaultValue = "PROPRIETARY"
  }
}

--- Read specified parameter from CMakeCache.txt file
-- @tparam string paramName Parameter to read value
-- @treturn string The main result. Value read of parameter. 
-- Can be nil in case parameter was not found.
-- @treturn string Type of read parameter
local function readParameterFromCMakeCacheFile(paramName)
  local pathToFile = config.pathToSDL .. "/CMakeCache.txt"
  if is_file_exists(pathToFile) then
    local paramValue, paramType
    for line in io.lines(pathToFile) do
      paramType, paramValue = string.match(line, "^%s*" .. paramName .. ":(.+)=(%S*)")
      if paramValue then
        return paramValue, paramType
      end
    end
  end
  return nil
end

--- Set SDL build option as values of SDL module property
-- @tparam table self Reference to SDL module
-- @tparam string optionName Build option to set value
-- @tparam string sdlBuildParam SDL build parameter to read value
-- @tparam string defaultValue Default value of set option
local function setSdlBuildOption(self, optionName, sdlBuildParam, defaultValue)
  local value, paramType = readParameterFromCMakeCacheFile(sdlBuildParam)
  if value == nil then
    value = defaultValue
    local msg = "SDL build option " ..
      sdlBuildParam .. " is unavailable.\nAssume that SDL was built with " ..
      sdlBuildParam .. " = " .. defaultValue
    print(console.setattr(msg, "cyan", 1))
  else
    if paramType == "UNINITIALIZED" then
      value = nil
      local msg = "SDL build option " ..
        sdlBuildParam .. " is unsupported."
      print(console.setattr(msg, "cyan", 1))
    end
  end
  self.buildOptions[optionName] = value
end

--- Set all SDL build options for SDL module of ATF
-- @tparam table self Reference to SDL module
local function setAllSdlBuildOptions(self)
  for option, data in pairs(usedBuildOptions) do
    setSdlBuildOption(self, option, data.sdlBuildParameter, data.defaultValue)
  end
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function SDL:StartSDL(pathToSDL, smartDeviceLinkCore, ExitOnCrash)
  if ExitOnCrash ~= nil then
    self.exitOnCrash = ExitOnCrash
  end
  local status = self:CheckStatusSDL()

  if (status == self.RUNNING) then
    local msg = "SDL had already started out of ATF"
    xmlReporter.AddMessage("StartSDL", {["message"] = msg})
    print(console.setattr(msg, "cyan", 1))
    return false, msg
  end

  local result = os.execute ('./tools/StartSDL.sh ' .. pathToSDL .. ' ' .. smartDeviceLinkCore)

  local msg
  if result then
    msg = "SDL started"
    if config.storeFullSDLLogs == true then
      sdl_logger.init_log(get_script_file_name())
    end
  else
    msg = "SDL had already started not from ATF or unexpectedly crashed"
    print(console.setattr(msg, "cyan", 1))
  end
  xmlReporter.AddMessage("StartSDL", {["message"] = msg})
  return result, msg

end

function SDL:StopSDL()
  self.autoStarted = false
  local status = self:CheckStatusSDL()
  if status == self.RUNNING then
    local result = os.execute ('./tools/StopSDL.sh')
    if result then
      if config.storeFullSDLLogs == true then
        sdl_logger.close()
      end
      return true
    end
  else
    local msg = "SDL had already stopped"
    xmlReporter.AddMessage("StopSDL", {["message"] = msg})
    print(console.setattr(msg, "cyan", 1))
    return nil, msg
  end
end

function SDL:CheckStatusSDL()
  local testFile = os.execute ('test -e sdl.pid')
  if testFile then
    local testCatFile = os.execute ('test -e /proc/$(cat sdl.pid)')
    if not testCatFile then
      return self.CRASH
    end
    return self.RUNNING
  end
  return self.STOPPED
end

function SDL:DeleteFile()
  if os.execute ('test -e sdl.pid') then
    os.execute('rm -f sdl.pid')
  end
end

setAllSdlBuildOptions(SDL)

return SDL
