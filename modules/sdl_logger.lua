
local module = { mt = { __index = {} },
                 is_open = true
                }

function module.init(host,port,logname)
    local res = 
    {
	host = host,
	port = port
    }
    module.socket  = network.TcpClient()
    if not module.socket then
      print("TcpClient returns nothing")
      return nil
    end
    module.sdl_log_file = io.open(logname,"w+")
    res.qtproxy = qt.dynamic()
    setmetatable(res, module.mt)
    return res
end
function module.dataReady()
    local data = module.socket:read(5000)
    module.sdl_log_file:write(data)
end
function module.Connect(self)
    self.qtproxy.dataReady = function() module.dataReady() end
    qt.connect(module.socket, "readyRead()", self.qtproxy, "dataReady()")
    module.socket:connect(self.host, self.port)
end

function module.close()
   module.socket:close()
--   io.close(module.sdl_log_file) -- fix me necessarty disconnect sygnal after file close 
end

return module
