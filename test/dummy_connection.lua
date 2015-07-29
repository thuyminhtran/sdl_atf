local module = {}
function module:OnInputData(func)
  self.on_input_data = func
end

function module:OnConnected(func)
  self.on_connected = func
end

function module:OnDisconnected(func)
  self.on_disconnected = func
end

function module:Disconnect()
  self.on_disconnected()
end
function module:InputData(data)
  self.on_input_data(data)
end
function module:Connect()
  self.on_connected()
end
return module
