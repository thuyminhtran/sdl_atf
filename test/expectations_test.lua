local expectations = require('expectations')
local ed = require("event_dispatcher")
local events = require("events")
local connection = require("test/dummy_connection")
local utils = require("debug/print_table")
local event_dispatcher = ed.EventDispatcher()

local Expectation = expectations.Expectation
local SUCCESS = expectations.SUCCESS
local FAILED = expectations.FAILED
event_dispatcher:AddConnection(connection)

function Truly() return true end
function Falsely() return false end
local id_ = 0

function new_id()
  id_ = id_ + 1
  return id_
end

local tests = {}

function tests:OneTrulyValidIf()
  local event = events.Event()
  local id = new_id()
  event.matches = function(self, data) return data.id == id end
  local ret = Expectation("Dummy expectation" .. id, connection):ValidIf(Truly)
  ret.event = event
  event_dispatcher:AddEvent(connection, event, ret)
  event_dispatcher:RaiseEvent(connection, {id = id})
  if ret.status ~= SUCCESS then
    return false, "if ValidIf Truly expectation should be Success"
  end
  return true
end

function tests:OneFalseluValidIf()
  local event = events.Event()
  local id = new_id()
  event.matches = function(self, data) return data.id == id end
  local ret = Expectation("Dummy expectation" .. id, connection):ValidIf(Falsely)
  ret.event = event
  event_dispatcher:AddEvent(connection, event, ret)
  event_dispatcher:RaiseEvent(connection, {id = id})
  if ret.status ~= FAILED then
    return false, "if ValidIf Falsely expectation should be False"
  end
  return true
end

function tests:TwoTrulyValidIf()
  local event = events.Event()
  local id = new_id()
  event.matches = function(self, data) return data.id == id end
  local ret = Expectation("Dummy expectation" .. id, connection)
  ret:ValidIf(Truly)
  ret:ValidIf(Truly)
  ret.event = event
  event_dispatcher:AddEvent(connection, event, ret)
  event_dispatcher:RaiseEvent(connection, {id = id})
  if ret.status ~= SUCCESS then
    return false, "if ValidIf Truly expectation should be Success"
  end
  return true
end

function tests:TwoFalseluValidIf()
  local event = events.Event()
  local id = new_id()
  event.matches = function(self, data) return data.id == id end
  local ret = Expectation("Dummy expectation" .. id, connection)
  ret:ValidIf(Falsely)
  ret:ValidIf(Falsely)
  ret.event = event
  event_dispatcher:AddEvent(connection, event, ret)
  event_dispatcher:RaiseEvent(connection, {id = id})
  if ret.status ~= FAILED then
    return false, "if ValidIf Falsely expectation should be False"
  end
  return true
end

function tests:TrueFalseValidIf()
  local event = events.Event()
  local id = new_id()
  event.matches = function(self, data) return data.id == id end
  local ret = Expectation("Dummy expectation" .. id, connection)
  ret:ValidIf(Truly)
  ret:ValidIf(Falsely)
  ret.event = event
  event_dispatcher:AddEvent(connection, event, ret)
  event_dispatcher:RaiseEvent(connection, {id = id})
  if ret.status ~= FAILED then
    return false, "if ValidIf Falsely expectation should be False"
  end
  return true
end

function tests:FalseTrueValidIf()
  local event = events.Event()
  local id = new_id()
  event.matches = function(self, data) return data.id == id end
  local ret = Expectation("Dummy expectation" .. id, connection)
  ret:ValidIf(Falsely)
  ret:ValidIf(Truly)
  ret.event = event
  event_dispatcher:AddEvent(connection, event, ret)
  event_dispatcher:RaiseEvent(connection, {id = id})
  if ret.status ~= FAILED then
    return false, "if ValidIf Falsely expectation should be False"
  end
  return true
end

local passed = true
for k,v in pairs(tests) do
  local res = v()
  if res then print ("PASSED", k)
  else print("FAILED", k) end
end
