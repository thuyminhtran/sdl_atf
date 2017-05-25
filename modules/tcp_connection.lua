local module = { mt = { __index = {} } }

function module.Connection(host, port)
  local res =
  {
    host = host,
    port = port
  }
  res.socket = network.TcpClient()
  setmetatable(res, module.mt)
  res.qtproxy = qt.dynamic()

  function res:inputData() end

  function res.qtproxy.readyRead()
    while true do
      local data = res.socket:read(81920)
      if data == '' then break end
      res.qtproxy:inputData(data)
    end
  end
  qt.connect(res.socket, "readyRead()", res.qtproxy, "readyRead()")

  return res
end

local function checkSelfArg(s)
  if type(s) ~= "table" or
  getmetatable(s) ~= module.mt then
    error("Invalid argument 'self': must be connection (use ':', not '.')")
  end
end

function module.mt.__index:Connect()
  xmlReporter.AddMessage("tcp_connection","Connect")
  checkSelfArg(self)
  self.socket:connect(self.host, self.port)
end

function module.mt.__index:Send(data)
  -- xmlReporter.AddMessage("tcp_connection","Send", data)
  checkSelfArg(self)
  for _, c in ipairs(data) do
    self.socket:write(c)
  end
end

function module.mt.__index:OnInputData(func)
  checkSelfArg(self)
  local d = qt.dynamic()
  local this = self
  function d:inputData(data)
    func(this, data)
  end
  qt.connect(self.qtproxy, "inputData(QByteArray)", d, "inputData(QByteArray)")
end

function module.mt.__index:OnDataSent(func)
  local d = qt.dynamic()
  local this = self
  function d:bytesWritten(num)
    func(this, num)
  end
  qt.connect(self.socket, "bytesWritten(qint64)", d, "bytesWritten(qint64)")
end

function module.mt.__index:OnConnected(func)
  checkSelfArg(self)
  if self.qtproxy.connected then
    error("Tcp connection: connected signal is handled already")
  end
  local this = self
  self.qtproxy.connected = function() func(this) end
  qt.connect(self.socket, "connected()", self.qtproxy, "connected()")
end

function module.mt.__index:OnDisconnected(func)
  checkSelfArg(self)
  if self.qtproxy.disconnected then
    error("Tcp connection: disconnected signal is handled already")
  end
  local this = self
  self.qtproxy.disconnected = function() func(this) end
  qt.connect(self.socket, "disconnected()", self.qtproxy, "disconnected()")
end

function module.mt.__index:Close()
  xmlReporter.AddMessage("tcp_connection","Close")
  checkSelfArg(self)
  self.socket:close();
end

return module
