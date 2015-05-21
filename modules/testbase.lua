local ed           = require("event_dispatcher")
local events       = require("events")
local expectations = require('expectations')
local console      = require('console')
local fmt          = require('format')
local config       = require('config')

local module = { }

local Expectation = expectations.Expectation
local SUCCESS     = expectations.SUCCESS
local FAILED      = expectations.FAILED

local control     = qt.dynamic()

local function isCapital(c)
  return 'A' <= c and c <= 'Z'
end

os.setlocale("C")

local mt =
{
  __index =
  {
    test_cases = { },
    case_names = { },
    descriptions = { },
    current_case_name = nil,
    current_case_index = 0,
    current_case_mandatory = false,
    expectations_list = expectations.ExpectationsList(),
    AddExpectation = function(self,e)
                       self.expectations_list:Add(e)
                     end,
    RemoveExpectation = function(self, e)
                          self.expectations_list:Remove(e)
                        end,
  },
  __newindex = function(t, k, v)
                 local firstLetter = string.sub(k, 1, 1)
                 if type(v) == "function" and isCapital(firstLetter)then
                   local function testcase(test)
                     function description(desc)
                       t.descriptions[k] = desc
                     end
                     function critical(val)
                       t.current_case_mandatory = val
                     end
                     t.current_case_name = k
                     t.current_case_mandatory = false
                     v(test)
                     t.ts = timestamp()
                   end
                   t.case_names[testcase] = k
                   table.insert(t.test_cases, testcase)
                 else
                   rawset(t, k, v)
                 end
               end,
  __metatable = { }
}

function control.runNextCase()
  module.current_case_index = module.current_case_index + 1
  local testcase = module.test_cases[module.current_case_index]
  if testcase then
    testcase(module)
  else
    quit()
  end
end

function control:start()
  -- if 'color' is not set, it is true as default value
  if config.color == nil then config.color = true end
  if is_redirected then config.color = false end
  self:next()
end

setmetatable(module, mt)

qt.connect(control, "next()", control, "runNextCase()")
qt.connect(control, "init()", control, "start()")

local function CheckStatus()
  if module.current_case_name == nil or module.current_case_name == '' then return end
  -- Check the test status
  if module.expectations_list:Any(function(e) return not e.status end) then return end
  local success = true
  local errorMessage = {}
  for _, e in ipairs(module.expectations_list) do
    if e.status ~= SUCCESS then
      success = false
    end
    if not e.pinned and e.connection then
      event_dispatcher:RemoveEvent(e.connection, e.event)
    end
    for k, v in pairs(e.errorMessage) do
      errorMessage[e.name .. ": " .. k] = v
    end
  end
  fmt.PrintCaseResult(module.current_case_name, success, errorMessage, timestamp() - module.ts)
  module.expectations_list:Clear()
  module.current_case_name = nil
  if module.current_case_mandatory and not success then
    quit()
  end
  control:next()
end

local function FailTestCase(self, cause)
  module.expectations_list:Clear()
  local exp = expectations.Expectation(cause)
  exp.status = FAILED
  exp.errorMessage = { ["AutoFail"] = cause }
  module.expectations_list:Add(exp)
  CheckStatus()
end
rawset(module, "FailTestCase", FailTestCase)

event_dispatcher = ed.EventDispatcher()
event_dispatcher:OnPostEvent(CheckStatus)
timeoutTimer = timers.Timer()
qt.connect(timeoutTimer, "timeout()", control, "checkstatus()")
function control:checkstatus()
  event_dispatcher:validateAll()
  CheckStatus()
end
timeoutTimer:start(400)
control:init()
return module
