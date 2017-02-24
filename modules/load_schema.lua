---- Facade for the Validation component.
--
--  Use `load_schema` for loading Mobile and HMI API validation schema.
--  
--  For more detail design information refer to @{Validation|Validation SDD} 
--  
--  Dependencies: `api_loader`, `schema_validation`
--  @module load_schema
--  @copyright [Ford Motor Company](https://smartdevicelink.com/partners/ford/) and [SmartDeviceLink Consortium](https://smartdevicelink.com/consortium/)
--  @license <https://github.com/smartdevicelink/sdl_core/blob/master/LICENSE>

local api_loader = require('api_loader')
local validator = require('schema_validation')

--- Table with a Mobile and HMI schema's
-- @field mob_schema Mobile validator
-- @field hmi_schema HMI validator
-- @table load_schema
local module = { }
module.response = 'response'
module.request = 'request'
module.notification = 'notification'
if (not module.mob_schema) then 
  module.mob_schema = validator.CreateSchemaValidator(api_loader.init("data/MOBILE_API.xml"))
end
if (not module.hmi_schema) then
  module.hmi_schema = validator.CreateSchemaValidator(api_loader.init("data/HMI_API.xml"))
end
return module