local xml = require("xml")
local mob_types = require("mob_validation")
local hmi_types = require("hmi_validation")

local module = {  mt = { __index = { } } }

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

function module.compare(schema,function_id, msgType,t2, mandatory_check)

  local doc = ''
  local t1 = {}
  local bool_result = true
  local errorMessage = {}
  local types = ''

  local function getXmlShemaVlidation(doc,types,name, msg_type)
    local retval= {}
    for _, v1 in ipairs(doc:xpath("//param/parent::function[@name='".. name .."']" )) do
	if (v1:attr("messagetype") == msg_type) then
    	    if (type(v1:children() == 'table')) then
    		for _, v2 in ipairs(v1:children()) do 
		    if(type(v2:attr('name')) ~= 'nil') then
			    local tmp = {}
			    if ( types.classes[v2:attr('type')]) then
				tmp['class'] = string.format("%s",v2:attr('type'))
			    end
			    if (types.enum[v2:attr('type')]) then
				tmp['class'] = "enum"
				tmp['type'] = string.format("%s",v2:attr('type'))
			    end
			    if (types.struct[v2:attr('type')]) then
				tmp['class']= "struct"
				tmp['type'] = string.format("%s",v2:attr('type'))
			    end

			    tmp['mandatory'] = (v2:attr('mandatory')) and v2:attr('mandatory') or 'true'
			    if (v2:attr('array')) then tmp['array'] = v2:attr('array') end
--			    retval['type'] = 
			    if (v2:attr('minsize') and v2:attr('maxsize')) then
				tmp['minsize'] = v2:attr('minsize')
				tmp['maxsize'] = v2:attr('maxsize')
			    end
			    if (v2:attr('minlength')) then tmp['minlength'] = v2:attr('minlength') end
			    if (v2:attr('maxlength')) then tmp['maxlength'] = v2:attr('maxlength') end
			    if (v2:attr('minvalue')) then tmp['minvalue'] = v2:attr('minvalue') end
			    if (v2:attr('maxvalue')) then tmp['maxvalue'] = v2:attr('maxvalue') end
			    retval[v2:attr('name')] = tmp
		    end
		end
            end
	end
    end
    return retval
    end
   
   local function errorMsgToString(tbl)
     local tmp = ''
      if type(tbl) == 'table' then
        for _,v in pairs(tbl) do
          if type(v) == 'table' then
              tmp = tmp ..'\n'..errorMsgToString(v)
          else
              tmp = tmp ..'\n'..v
          end       
        end
        return tmp
      else 
        return tostring(tbl)
      end  
   end
   local function compare_type(elem1, elem2)
	local retVal = true
	while true do
	    if     (elem1 == 'number'  and elem2 == 'Integer') then break
	    elseif (elem1 == 'number'  and elem2== 'Float')    then break
	    elseif (elem1 == 'string'  and elem2== 'String')   then break
	    elseif (elem1 == 'boolean'  and elem2== 'Boolean')   then break
	    else retVal = false
	        break 
	    end
	end
    return retVal
   end

  local function nodeVerify(xmlNode,dataNode, key)
          if (xmlNode.class == 'enum') then
            if (not types.enum[ dataNode ] and type(dataNode) ~= 'table') then
		    bool_result = false 
		    errorMessage[ key ] = "expecoted: '" .. key .."' with type  [ Enum ]"
	    end
	  elseif (xmlNode.class == 'struct') then
            if (not types.struct[ dataNode ] and type(dataNode) ~= 'table') then
		    bool_result = false 
		    errorMessage[ key ] = "expected: '" .. key .."' with type  [ Struct ]"
	    end
          elseif xmlNode.array == 'true' then
	    if (type(dataNode) == 'table' ) then
		    for _,arrElement in ipairs(dataNode) do
		      while true do
			if (xmlNode.class == 'Enum' and types.enum[ dataNode ] ) then break
			elseif (xmlNode.class == 'Struct' and types.struct[ dataNode ] ) then break
			elseif(compare_type(string.lower(type(arrElement)), xmlNode.class)) then break
			else
	    		    bool_result = false
    			    errorMessage[ key ] = "not valid type: into "..key .. " " .. string.lower(type(arrElement)) .. " " .. xmlNode.class
			    break
			end
		      end
		    end
	    else
		bool_result = false
		errorMessage[ key ] = "expected: '" .. key .."' with type  [ array ]"
	    end
          else
	    if (types.classes[xmlNode.class] ~= 'nil') then 
		    if (not  compare_type(string.lower(type(dataNode)), xmlNode.class) ) then
    			bool_result = false
    			errorMessage[ key ] = "not valid type: "..key .." - ".. string.lower(type(dataNode)) .." - ".. xmlNode.class
		    end
	    else
		errorMessage[ key ] = "not valid type: "..key
	    end
          end
  end

   local function schemaCompare(t1,t2)
   if (type(t1)~="table") then 
      return nil, "Empty Data" 
   end
    
   if (not mandatory_check) then
      for k2,v2 in pairs(t2) do
      if(t1[k2] ~= 'nil') then
	  nodeVerify(t1[k2], t2[k2], k2)
      else
	    bool_result = false
	    errorMessage[ k2 ] = "not valid property: ".. k2
      end
      end
    else
	for k1,v1 in pairs(t1) do
	    if(t2[k1]) then
		nodeVerify(t1[k1], t2[k1], k1)
	    else
	         if(t1[k1].mandatory == 'true') then
	    	    bool_result = false
		    errorMessage[ k1 ] = "not present : ".. k1
	    	 end
		
	    end
	end
    end

    return bool_result, errorMsgToString(errorMessage)
  end
 
  
   if (schema == 'hmi') then
      doc = xml.open("data/MOBILE_API.xml")
      if not doc then return nil,"Cannot open data/MOBILE_API.xml" end
      types = hmi_types
  elseif (schema == 'mobile') then
      doc = xml.open("data/HMI_API.xml")    
      if not doc then return nil,"Cannot open data/HMI_API.xml" end
      types = mob_types        
  else 
      return nil,"Uncknown schema type"
  end

   t1 = getXmlShemaVlidation(doc,types,function_id,msgType)  
  
  if (type(mandatory_check) == 'boolean') then
      mandatory_check = mandatory_check or false
  else
     mandatory_check = false
  end
  
  return schemaCompare(t1,t2)
  
end 

return module