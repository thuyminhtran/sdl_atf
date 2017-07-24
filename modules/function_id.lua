local xml = require('xml')

local function CopyFile(file, newfile)
  return os.execute (string.format('cp "%s" "%s"', file, newfile))
end

local function CopyInterface()
  if config.pathToSDLInterfaces~="" and config.pathToSDLInterfaces~=nil then
    local mobile_api = config.pathToSDLInterfaces .. '/MOBILE_API.xml'
    local hmi_api = config.pathToSDLInterfaces .. '/HMI_API.xml'
    CopyFile(mobile_api, 'data/MOBILE_API.xml')
    CopyFile(hmi_api, 'data/HMI_API.xml')
  end
end

CopyInterface()

local module = { }

module.mobile_functions = { }

local mobile_api = xml.open("data/MOBILE_API.xml")

local ids = { }
for _, f in ipairs(mobile_api:xpath("//enum[@name='FunctionID']/element")) do
  ids[f:attr("name")] = f:attr("value")
end
for _, f in ipairs(mobile_api:xpath("//function")) do
  module.mobile_functions[f:attr("name")] = tonumber(ids[f:attr("functionID")])
end

return module.mobile_functions
