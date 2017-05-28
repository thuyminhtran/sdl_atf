--- Module which is responsible for loading Mobile and HMI API validation schema.
--
-- Dependencies: `api_loader`, `schema_validation`
--
-- *Globals:* none
-- @module load_schema
-- @copyright [Ford Motor Company](https://smartdevicelink.com/partners/ford/) and [SmartDeviceLink Consortium](https://smartdevicelink.com/consortium/)
-- @license <https://github.com/smartdevicelink/sdl_core/blob/master/LICENSE>

local api_loader = require('api_loader')
local validator = require('schema_validation')

--- Table with a Mobile and HMI schema's
-- @table LoadSchema
-- @tfield Validator mob_schema Mobile validator
-- @tfield Validator hmi_schema HMI validator
-- @tfield string response Const for Response
-- @tfield string request Const for Request
-- @tfield string notification Const for Notification

local LoadSchema = { }
module.response = 'response'
module.request = 'request'
module.notification = 'notification'
if (not module.mob_schema) then
  module.mob_schema = validator.CreateSchemaValidator(api_loader.init("data/MOBILE_API.xml"))
end
if (not module.hmi_schema) then
  module.hmi_schema = validator.CreateSchemaValidator(api_loader.init("data/HMI_API.xml"))
end

return LoadSchema
