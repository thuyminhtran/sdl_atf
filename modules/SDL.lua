require('os')

local SDL = { }

SDL.exitOnCrash = true
SDL.autoRun = false

SDL.STOPPED = 0
SDL.RUNNING = 1
SDL.CRASH = -1

function SDL:StartSDL(pathToSDL, smartDeviceLinkCore, ExitOnCrash)
  xmlReporter:initSDLLOG()
  if ExitOnCrash then
    self.exitOnCrash = ExitOnCrash
  end
  local status = self:CheckStatusSDL()
  if status == self.STOPPED then
    local result = os.execute ('./StartSDL.sh ' .. pathToSDL .. ' ' .. smartDeviceLinkCore)
    if result then
      return true
    else
      local msg = "SDL had already started not from ATF or unexpectedly crashed"
      print(console.setattr(msg, "cyan", 1))
      return nil, msg
    end
  end
  local msg = "SDL had already started from ATF"
  print(console.setattr(msg, "cyan", 1))
  return nil, msg
end

function SDL:StopSDL()
  self.autoStarted = false
  local status = self:CheckStatusSDL()
  if status == self.RUNNING then
    local result = os.execute ('./StopSDL.sh')
    if result then
      return true
    end
  else
    local msg = "SDL had already stopped"
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

return SDL
