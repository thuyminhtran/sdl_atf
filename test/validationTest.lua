local validator = require("schema_validation")

local load_schema = require("load_schema")

local mob_schema = load_schema.mob_schema
local hmi_schema = load_schema.hmi_schema

local json_hmi_tbl = { numTicks = 7, position = 6, sliderHeader ="sliderHeader",
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
  appID = 1
}

local function text_field(name, characterSet, width, rows)
  return
    {
      name = name,
      characterSet = characterSet or "TYPE2SET",
      width = width or 500,
      rows = rows or 1
    }
    end
local function image_field(name, width, heigth)
  return
  {
    name = name,
    imageTypeSupported =
    {
      "GRAPHIC_BMP",
      "GRAPHIC_JPEG",
      "GRAPHIC_PNG"
    },
    imageResolution =
    {
      resolutionWidth = width or 64,
      resolutionHeight = height or 64
    }
  }
end

local json_capabilities = {
  displayCapabilities = {
    displayType = "GEN2_8_DMA",
    textFields = {
      text_field("mainField1"),
      text_field("mainField2"),
      text_field("mainField3"),
      text_field("mainField4"),
      text_field("statusBar"),
      text_field("mediaClock"),
      text_field("mediaTrack")
    },
    imageFields = {
      image_field("softButtonImage"),
      image_field("choiceImage"),
      image_field("choiceSecondaryImage"),
      image_field("vrHelpItem"),
      image_field("turnIcon"),
      image_field("menuIcon"),
      image_field("cmdIcon"),
      image_field("showConstantTBTIcon"),
      image_field("showConstantTBTNextTurnIcon"),
      image_field("locationImage")
    },
    mediaClockFormats = {
      "CLOCK1",
      "CLOCK2",
      "CLOCK3",
      "CLOCKTEXT1",
      "CLOCKTEXT2",
      "CLOCKTEXT3",
      "CLOCKTEXT4"
    },
    graphicSupported = true,
    imageCapabilities = {
      "DYNAMIC",
      "STATIC"
    },
    templatesAvailable = {
      "TEMPLATE"
    },
    screenParams = {
      resolution = {
        resolutionWidth = 800,
        resolutionHeight = 480
      },
      touchEventAvailable = {
        pressAvailable = true,
        multiTouchAvailable = true,
        doublePressAvailable = false
      }
    },
    numCustomPresetsAvailable = 10
  },
  audioPassThruCapabilities = {
    samplingRate = "44KHZ",
    bitsPerSample = "8_BIT",
    audioType = "PCM"
  },
  hmiZoneCapabilities = "FRONT",
  softButtonCapabilities = {
    {
      shortPressAvailable = true,
      longPressAvailable = true,
      upDownAvailable = true,
      imageSupported = true
    }
  }
  }

  local json_capabilities_wrong = {
  displayCapabilities = {
    displayType = "GEN2_8_DMA",
    textFields = {
      text_field("mainField1"),
      text_field("mediaTrack"),
      text_field("media", 0) --wrong parameter of text field
    },
    imageFields = {
      image_field("softButtonImage"),
      image_field("choiceImage"),
      image_field("choiceSecondaryImage"),
    },
    image_field("choiceSecondaryImage"), --wrong paramater
    mediaClockFormats = {
      "CLOCK1",
      "CLOCKTEXT4"
    },
    graphicSupported = true,
    imageCapabilities = {
      "DYNAMIC",
      {"STATIC"}
    },
    templatesAvailable = {
      "TEMPLATE",
      1-- wrong enum
    },
    screenParams = {
      resolution = {
        resolutionWidth = true, --should be integer
        resolutionHeight = 480
      },
      touchEventAvailable = {
        pressAvailable = true,
        multiTouchAvailable = true
        -- doublePressAvailable = false --mandatory parameter
      }
    },
    numCustomPresetsAvailable = 10
  },
  audioPassThruCapabilities = {
    samplingRate = "44KHZ",
    bitsPerSample = "8_BIT",
    audioType = "PCM"
  },
  hmiZoneCapabilities = "FRONT",
  softButtonCapabilities = {
    {
      shortPressAvailable = true,
      longPressAvailable = true,
      upDownAvailable = true,
      imageSupported = true
    }
  }
  }


json_hmi_ButtonCapabilities_tbl2 = {
  capabilities = {
    {
      name= "PRESET_1",
      shortPressAvailable = true,
      longPressAvailable = false,
      upDownAvailable = true, 
    } , 
    {
      name= "PRESET_2",
      shortPressAvailable = true,
      longPressAvailable = false,
      upDownAvailable = false, 
    }
  },
  presetBankCapabilities={onScreenPresetsAvailable=true}
}

json_hmi_ButtonCapabilities_tbl3 = {
  capabilities = 
  {
    name= "PRESET_1",
    shortPressAvailable = true,
    longPressAvailable = false,
    upDownAvailable = true, 
  }
}

json_hmi_ButtonCapabilities_tbl4 = {
  capabilities = {
  {
    name= "PRESET_1",
    shortPressAvailable = true,
    longPressAvailable = 1,
    upDownAvailable = true, 
  } , 
  {
    name= "PRESET_2",
    shortPressAvailable = true,
    longPressAvailable = false,
    upDownAvailable = 2, 
  }
  },
  presetBankCapabilities={onScreenPresetsAvailable="true"}
}

local json_mob_tbl = {success = true, resultCode = {"SUCCESS"}}

local _res, _err = hmi_schema:Validate('UI.GetCapabilities', 'response', json_capabilities) 
if _res then
  print("validate_hmi_response UI.GetCapabilities:"..tostring(_res))
else
  print("validate_hmi_response UI.GetCapabilities:"..tostring(_res).." ==> ".._err)
end

local _res, _err = hmi_schema:Validate('Buttons.GetCapabilities',  'response', json_hmi_ButtonCapabilities_tbl2)
if _res then
  print("validate_hmi_response Buttons.GetCapabilities:"..tostring(_res))
else
  print("validate_hmi_response Buttons.GetCapabilities:"..tostring(_res).." ==> ".._err)
end

local _res, _err = hmi_schema:Validate('UI.Slider',  'request', json_hmi_tbl) 
if _res then
  print("validate_hmi_request:"..tostring(_res))
else
  print("validate_hmi_request:"..tostring(_res).." ==> ".._err)
end


_res, _err = mob_schema:Validate('Slider', 'response',  { success = true, resultCode = "SUCCESS" },true)
if _res then
  print("validate_mobile_response:"..tostring(_res))
else
  print("validate_mobile_response:"..tostring(_res).." ==> ".._err)
end


_res, _err = mob_schema:Validate("WrongFunctionName", "response", { success = false, resultCode = "INVALID_DATA", info = nil })
if _res then
  print("validate_mobile_response with \"WrongFunctionName\":"..tostring(_res))
else
  print("validate_mobile_response with \"WrongFunctionName\":"..tostring(_res).." ==> ".._err)
end

_res, _err = hmi_schema:Validate("BasicCommunication.OnSystemRequest", 'notification',  { requestType = "PROPRIETARY"})
if _res then
  print("validate_hmi_notification:"..tostring(_res))
else
  print("validate_hmi_notification:"..tostring(_res).." ==> ".._err)
end

_res, _err = hmi_schema:Validate('BasicCommunication.OnSystemRequest', "notification", { url = "default", fileName = "fileName"}, true)
if _res then
  print("validate_hmi_notification:"..tostring(_res))
else
  print("validate_hmi_notification:"..tostring(_res).." ==> ".._err)
end

_res, _err =mob_schema:Validate("PerformInteraction", "request",  { initialText = "initialText",
    initialPrompt = {{text = "initialPrompt", type = "TEXT"}},
    interactionMode = "MANUAL_ONLY",
    interactionChoiceSetIDList = {1},
    helpPrompt = {{text = "helpPrompt", type = "TEXT"}},
    interactionLayout = "KEYBOARD"
  })
if _res then
  print("validate_mobile_request:"..tostring(_res))
else
  print("validate_mobile_request:"..tostring(_res).." ==> ".._err)
end


print("======================= Negative case \n")

_res, _err =mob_schema:Validate("OnHMIStatus", "notification", {hmiLevel = "FULL", AAA=0})
if _res then
  print("validate_modile_notification:"..tostring(_res))
else
  print("validate_mobile_notification:"..tostring(_res).." ==> ".._err)
end

print("======================= Negative case \n")
_res, _err = mob_schema:Validate('Slider', 'response',  { success = 'true', resultCode = {"SUCCESS"} },true)
if _res then
  print("validate_mobile_response:"..tostring(_res))
else
  print("validate_mobile_response:"..tostring(_res).." ==> ".._err)
end

print("======================= Negative case \n")
local _res, _err = hmi_schema:Validate('Buttons.GetCapabilities', 'response', json_hmi_ButtonCapabilities_tbl3)
if _res then
  print("validate_hmi_request:"..tostring(_res))
else
  print("validate_hmi_request:"..tostring(_res).." ==> ".._err)
end


print("======================= Negative case \n")
local _res, _err = hmi_schema:Validate('Buttons.GetCapabilities', 'response', json_hmi_ButtonCapabilities_tbl4)
if _res then
  print("validate_hmi_response Buttons.GetCapabilities:"..tostring(_res))
else
  print("validate_hmi_response Buttons.GetCapabilities:"..tostring(_res).." ==> ".._err)
end

print("======================= Negative case \n")
_res, _err = mob_schema:Validate('Slider', 'response', json_mob_tbl, true)
if _res then
  print("validate_mobile_response:"..tostring(_res))
else
  print("validate_mobile_response:"..tostring(_res).." ==> ".._err)
end

print("======================= Negative case \n")
local _res, _err = hmi_schema:Validate('UI.GetCapabilities', 'response', json_capabilities_wrong) 
if _res then
  print("validate_hmi_response UI.GetCapabilities:"..tostring(_res))
else
  print("validate_hmi_response UI.GetCapabilities:"..tostring(_res).." ==> ".._err)
end

quit()
