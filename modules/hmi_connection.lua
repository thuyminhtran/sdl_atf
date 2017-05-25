local json = require("json")
local api_loader = require("modules/api_loader")

local module = { mt = { __index = { } } }

function module.mt.__index:Connect()
  self.connection:Connect()
end

local function getResultCodes( )
  local hmi_schema = api_loader.init("data/HMI_API.xml")
  return hmi_schema.interface["Common"].enum["Result"]
end

local resultCodes = getResultCodes()

function module.mt.__index:Send(text)
  xmlReporter.AddMessage("hmi_connection","Send",{["json"] = tostring(text)})
  self.connection:Send(text)
end

function module.mt.__index:SendRequest(methodName, params)
  data = {}
  self.requestId = self.requestId + 1
  data.jsonrpc = "2.0"
  data.id = self.requestId
  data.method = methodName
  data.params = params
  local text = json.encode(data)
  self:Send(text)
  xmlReporter.AddMessage("hmi_connection",{["RequestId"] = tostring(self.requestId),["Type"] = "SendRequest"},{ ["methodName"] = methodName,["params"]=params } )
  return self.requestId
end

function module.mt.__index:SendNotification(methodName, params)
  xmlReporter.AddMessage("hmi_connection","SendNotification",{ ["methodName"] = methodName, ["params"] = params } )
  local data = {}
  data.method = methodName
  data.jsonrpc = "2.0"
  data.params = params
  local text = json.encode(data)
  self:Send(text)
end

function module.mt.__index:SendResponse(id, methodName, code, params)
  xmlReporter.AddMessage("hmi_connection","SendResponse",{ ["id"] = id, ["methodName"] = tostring(methodName), ["code"] = code , ["params"] = params} )
  local data = {}
  self.requestId = self.requestId + 1
  data.jsonrpc = "2.0"
  data.id = id
  data.result = {
    method = methodName,
    code = resultCodes[code]
  }
  if params ~= nil then
    for k, v in pairs(params) do
      data.result[k] = v
    end
  end
  local text = json.encode(data)
  self:Send(text)
end

function module.mt.__index:SendError(id, methodName, code, errorMessage)
  xmlReporter.AddMessage("hmi_connection","SendError",{["id"] = id, ["methodName"] = methodName, ["code"] = code,["errorMessage"] = errorMessage } )
  local data = {}
  data.error = {}
  data.error.data = {}
  data.id = id
  data.jsonrpc = "2.0"
  data.error.data.method = methodName
  data.error.code = resultCodes[code]
  data.error.message = errorMessage
  local text = json.encode(data)
  self:Send(text)
end

function module.mt.__index:OnInputData(func)
  self.connection:OnInputData(function(_, data)
      func(self, data)
    end)
end

function module.mt.__index:OnConnected(func)
  self.connection:OnConnected(function() func(self) end)
end

function module.mt.__index:OnDisconnected(func)
  self.connection:OnDisconnected(function() func(self) end)
end

function module.mt.__index:Close()
  self.connection:Close()
end

function module.Connection(connection)
  local res = { }
  res.connection = connection
  res.requestId = 0
  setmetatable(res, module.mt)
  return res
end

return module
