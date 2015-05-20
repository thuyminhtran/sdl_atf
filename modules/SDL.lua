local os         = require('os')

local SDL = { }

SDL.exitOnCrash = true
SDL.autoRun = false

function SDL:StartSDL(pathToSDL, ExitOnCrash)
  if ExitOnCrash ~= nil then
    self.exitOnCrash = ExitOnCrash
  end
  local status = self:CheckStatusSDL()
  if status == "Stopped" then
    local result = os.execute ('./StartSDL ' .. pathToSDL)
    if result then
      return true
    else
      return nil, "SDL had already started from not ATF" 
    end
  else
    return nil, "SDL had already started from ATF"
  end
end

function SDL:StopSDL()
  local status = self:CheckStatusSDL()
  if status == "Running" then
    local result = os.execute ('./StopSDL')
    if result then 
      return true
    end
  else
    return nil, "SDL had already stopped"
  end
end

function SDL:CheckStatusSDL()
  local result1 = os.execute ('./checkFile')
  if result1 then 
    local result2 = os.execute ('./checkCrash')
    if result2 then
      return "Crash"
    else
      return "Running"
    end
  else
    return "Stopped"
  end
end

function SDL:DeleteFile()
  os.execute ('rm sdl.pid')
end

return SDL
