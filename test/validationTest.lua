local validator = require("schema_validation")

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

local json_registreAppInterface = {
                success = true,
                resultCode = "SUCCESS",
                vehicleType = {
                        make = "Ford from policy",
                        model = "Fiesta from policy",
                        modelYear = "2222"
                        } }

local json_mob_tbl =  { success = true, resultCode = {"SUCCESS"} }

local _res, _err = validator.validate_hmi_request('Slider', json_hmi_tbl)
if (not _res) then  print(_err) else  print (_res) end

_res, _err = validator.validate_mobile_response('Slider',json_mob_tbl,true)
if (not _res) then  print(_err) else  print (_res) end

_res, _err = validator.validate_mobile_response( 'Slider',{ success = 'true', resultCode = {"SUCCESS"} },true)
if (not _res) then  print(_err) else  print (_res) end

quit()
