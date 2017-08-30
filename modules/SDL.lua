--- The module which is responsible for managing SDL from ATF
--
-- *Dependencies:* `os`, `sdl_logger`, `config`, `atf.util`
--
-- *Globals:* `sleep()`, `CopyFile()`, `CopyInterface()`, `xmlReporter`, `console`
-- @module SDL
-- @copyright [Ford Motor Company](https://smartdevicelink.com/partners/ford/) and [SmartDeviceLink Consortium](https://smartdevicelink.com/consortium/)
-- @license <https://github.com/smartdevicelink/sdl_core/blob/master/LICENSE>

require('os')
local sdl_logger = require('sdl_logger')
local config = require('config')
local SDL = { }

require('atf.util')
--- The flag responsible for stopping ATF in case of emergency completion of SDL
SDL.exitOnCrash = true
--- SDL state constant: SDL completed correctly
SDL.STOPPED = 0
--- SDL state constant: SDL works
SDL.RUNNING = 1
--- SDL state constant: SDL crashed
SDL.CRASH = -1

--- A global function for organizing execution delays (using the OS)
-- @tparam number n The delay in ms
function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

--- Global function for copying a file (using the OS)
-- @tparam string file Original file
-- @tparam string newfile Result file
function CopyFile(file, newfile)
  return os.execute (string.format('cp "%s" "%s"', file, newfile))
end

--- Global function for copying SDL interfaces (mobile_api.xml, hmi_api.xml)
function CopyInterface()
  if config.pathToSDLInterfaces~="" and config.pathToSDLInterfaces ~= nil then
    local mobile_api = config.pathToSDLInterfaces .. '/MOBILE_API.xml'
    local hmi_api = config.pathToSDLInterfaces .. '/HMI_API.xml'
    CopyFile(mobile_api, 'data/MOBILE_API.xml')
    CopyFile(hmi_api, 'data/HMI_API.xml')
  end
end

--- Launch SDL from ATF
-- @tparam string pathToSDL Path to SDL
-- @tparam string smartDeviceLinkCore The name of the SDL to run
-- @tparam boolean ExitOnCrash Flag whether Stop ATF in case SDL shutdown
-- @treturn boolean The main result. Indicates whether the launch of SDL was successful
-- @treturn string Additional information on the main SDL startup result
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

--- Stop SDL from ATF (SIGINT is used)
-- @treturn nil The main result. Always nil.
-- @treturn string Additional information on the main result of stopping SDL
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

--- SDL status check
-- @treturn number SDL state
--
-- SDL.STOPPED = 0 Completed the work correctly
--
-- SDL.RUNNING = 1 Running
--
-- SDL.CRASH = -1 Crash
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

--- Deleting an SDL process indicator file
function SDL:DeleteFile()
  if os.execute ('test -e sdl.pid') then
    os.execute('rm -f sdl.pid')
  end
end

return SDL
