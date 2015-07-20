Test = require('connecttest')
require('cardinalities')
config = require('config')
module = require('testbase')

function Test:WaitActivation()
  EXPECT_NOTIFICATION("OnHMIStatus")
  local rid = self.hmiConnection:SendRequest("SDL.ActivateApp", { appID = self.applications["Test Application"] })
  EXPECT_HMIRESPONSE(rid)
end

function Test:Any_Test()
  EXPECT_HMICALL("UI.Slider",
    {
      numTicks = 2,
      position = 2,
      sliderHeader = "Slider Header",
      timeout = 5000,
      sliderFooter = { "Slider Footer" }
    })
  :Do(function(_,data)
      self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {})
    end)
  local cid = self.mobileSession:SendRPC("Slider",
    {
      numTicks = 2,
      position = 2,
      sliderHeader = "Slider Header",
      timeout = 5000,
      sliderFooter = { "Slider Footer" }
    })
  EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS" })
end

function Test:StopSDL()
  StopSDL()
end

function Test:StartSDL()
  StartSDL(config.pathToSDL, config.ExitOnCrash)
end

function module:InitHMI2()
  self:initHMI()
end

function module:InitHMI_onReady2()
  self:initHMI_onReady()
end

function module:ConnectMobile2()
  self:connectMobile()
end

function module:StartSession2()
  self:startSession()
end

function Test:Any_Test2()
  EXPECT_HMICALL("UI.Slider",
    {
      numTicks = 2,
      position = 2,
      sliderHeader = "Slider Header",
      timeout = 5000,
      sliderFooter = { "Slider Footer" }
    })
  :Do(function(_,data)
      self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {})
    end)
  local cid = self.mobileSession:SendRPC("Slider",
    {
      numTicks = 2,
      position = 2,
      sliderHeader = "Slider Header",
      timeout = 5000,
      sliderFooter = { "Slider Footer" }
    })
  EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS" })
end

function Test:StopSDL()
  StopSDL()
end

function Test:StopAlreadyStopedSDL()
  StopSDL()
end

function Test:StartSDL()
  StartSDL(config.pathToSDL, config.ExitOnCrash)
end

function Test:RunAlreadyStartSDL()
  StartSDL()
end
function Test:DelayedExp()
  local event = events.Event()
  event.matches = function(self, e) return self == e end
  EXPECT_EVENT(event, "Delayed event")
  RUN_AFTER(function()
      RAISE_EVENT(event, event)
      end, 10000)
  end

  function Test:StopSDL()
    StopSDL()
  end
