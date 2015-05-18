local validator = require("schema_validation")
Test = require('connecttest')
require('cardinalities')
local config = require('config')


local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} \n'
   else
      return tostring(o)
   end
end

local json_hmi_tbl = { numTicks = 7,position = 6,sliderHeader ="sliderHeader",
	sliderFooter = 
	{ 
	    "sliderFooter1",
	    "sliderFooter2",
	    "sliderFooter3",
	    "sliderFooter4",
	    "sliderFooter5",
	    "sliderFooter6",
	    "sliderFooter7",
	}, 
	timeout = 3000,
        }

local json_mob_tbl =  { success = "true", resultCode = {"SUCCESS"} }
local _res, _err = validator.compare('hmi', 'Slider', 'request', json_hmi_tbl)

if (not _res) then  print(_err)
else  print (_res) end

_res, _err = validator.compare('mobile', 'Slider', 'response',json_mob_tbl,true)

if (not _res) then  print(_err)
else  print (_res) end

quit()
