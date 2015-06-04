Test = require('connecttest')
require('cardinalities')
local events = require('events')
local mobile_session = require('mobile_session')
local config = require('config')

local function DelayedExp(time)
  local event = events.Event()
  event.matches = function(self, e) return self == e end
  EXPECT_EVENT(event, "Delayed event")
    :Timeout(time + 1000)
  RUN_AFTER(function()
              RAISE_EVENT(event, event)
            end, time)
end

function Test:WaitActivation()
  EXPECT_NOTIFICATION("OnHMIStatus")
  local rid = self.hmiConnection:SendRequest("SDL.ActivateApp", { appID = self.applications["Test Application"]})
  EXPECT_HMIRESPONSE(rid)
  self.mobileSession:ExpectEvent(events.disconnectedEvent, "Connection started")
    :Pin()
    :Times(AnyNumber())
    :Do(function()
          print("Disconnected!!!")
          quit()
        end)
end

function Test:StartSecondSession()
  self.mobileSession2 = mobile_session.MobileSession(
    self,
    self.mobileConnection,
    config.application2.registerAppInterfaceParams)
  self.mobileSession2:Start()
    :Do(function()
         print("Session #", self.mobileSession2.sessionId,  "started")
        end)    
end

function Test:StartThirdSession()
  self.mobileSession3 = mobile_session.MobileSession(
    self,
    self.mobileConnection,
    config.application3.registerAppInterfaceParams)
  self.mobileSession3.version = 2 
  self.mobileSession3:Start()
    :Do(function()
         print("Session #", self.mobileSession3.sessionId,  "started")
        end)    
end

function Test:Wait()
  DelayedExp(7000)
end

function Test:StopHB()
  self.mobileSession:StopHeartbeat()
end

function Test:Wait2()
  DelayedExp(10000)
end

function Test:SetTimeout()
  self.mobileSession3.version = 3 -- this is not enought to start HB for this session. You need to start session with protocol version >= 3.
  self.mobileSession:StartHeartbeat()
  self.mobileSession:SetHeartbeatTimeout(1000)
  self.mobileSession2:SetHeartbeatTimeout(2000)
end

function Test:Wait3()
  DelayedExp(5000)
end

function Test:IgnoreHeartbeat()
  self.mobileSession2.sendHeartbeatToSDL = false  
  self.mobileSession2.answerHeartbeatFromSDL = false  
end

function Test:Wait4()
  DelayedExp(5000)
end




