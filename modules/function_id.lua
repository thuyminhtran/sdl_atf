local xml = require('xml')
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
