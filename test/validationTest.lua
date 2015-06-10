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

local json_mob_tbl =  {success = true, resultCode = {"SUCCESS"}}

local _res, _err = validator.validate_hmi_request('Slider', json_hmi_tbl)
if (not _res) then  print("validate_hmi_request:"..tostring(_res).." ==> ".._err) else  print ("validate_hmi_request:"..tostring(_res)) end

_res, _err = validator.validate_mobile_response('Slider',json_mob_tbl,true)
if (not _res) then  print("validate_mobile_response:"..tostring(_res).." ==> ".._err) else  print ("validate_mobile_response:"..tostring(_res)) end

_res, _err = validator.validate_mobile_response( 'Slider',{ success = 'true', resultCode = {"SUCCESS"} },true)
if (not _res) then  print("validate_mobile_response:"..tostring(_res).." ==> ".._err) else  print ("validate_mobile_response:"..tostring(_res)) end

_res, _err = validator.validate_hmi_notification( 'OnSystemRequest', { requestType = {"PROPRIETARY"}, urlSchema = "default"})
if (not _res) then  print("validate_hmi_notification:"..tostring(_res).." ==> ".._err) else  print ("validate_hmi_notification:"..tostring(_res)) end

_res, _err = validator.validate_hmi_notification( 'OnSystemRequest', { urlSchema = "default"},true)
if (not _res) then  print("validate_hmi_notification:"..tostring(_res).." ==> ".._err) else  print ("validate_hmi_notification:"..tostring(_res)) end

_res, _err = validator.validate_mobile_notification( "OnHMIStatus", {hmiLevel = "FULL"}) 
if (not _res) then  print("validate_mobile_notification:"..tostring(_res).." ==> ".._err) else  print ("validate_modile_notification:"..tostring(_res)) end

_res, _err = validator.json_validate(json_mob_tbl, {resultCode = {"SUCCESS"} })
if (not _res) then  print("json_validate:"..tostring(_res).." ==> ".._err) else  print ("json_validate:"..tostring(_res)) end

_res, _err = validator.json_validate(json_mob_tbl, { success = 'true', resultCode = {"SUCCESS"} } )
if (not _res) then  print("json_validate:"..tostring(_res).." ==> ".._err) else  print ("json_validate:"..tostring(_res)) end

local _res, _err = validator.validate_hmi_request('PerformInteraction', 
{ initialText = "initialText",
    initialPrompt = {{text = "initialPrompt", type = "TEXT"}},
    interactionMode = "MANUAL_ONLY",
    interactionChoiceSetIDList = {1},
    helpPrompt = {{text = "helpPrompt", type = "TEXT"}},
    interactionLayout = "KEYBOARD"
})
if (not _res) then  print("validate_hmi_request:"..tostring(_res).." ==> ".._err) else  print ("validate_hmi_request:"..tostring(_res)) end


quit()
