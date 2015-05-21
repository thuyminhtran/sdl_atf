local xml     = require("xml")
local io      = require("atf.stdlib.std.io")
local sdl_log = require("sdl_logger")

local module = {
--                logLevel = 1, --see log level comment
		        timestamp='',
		        ndoc = {},
                curr_node={},
		        root = {},
		        curr_report_name = {},
                full_sdlLog_name ='' ,
		        mt={_index={}}
		        }
                
local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = \"' .. dump(v) .. '\",'
      end
      return s .. '}'
   elseif string.match(tostring(o),"[%Wxyz]") then 
    return ''
   else
      return tostring(o)
   end
end
function module.AddCase(name)
   module.curr_node = module.root:addChild(name) 
   module.ndoc:write(module.curr_report_name)
end
function module.AddMessage(name,funcName,...)
    local attrib = table.pack(...)[1]
    local msg =  module.curr_node:addChild(name)

    if (type(funcName) ~= 'table') then 
        msg:attr("FunctionName",funcName)
    else
        for an, av in pairs(funcName) do
            msg:attr(an,av)
        end    
    end
    if (type(attrib) == 'table') then
        msg:text(dump(attrib))   
    elseif(attrib ~= nil) then
         msg:text(attrib)
    end
end
function module.CaseMessageTotal(name, ... )
   local attrib = table.pack(...)[1]
   for attr_n,attr_v in pairs(attrib) do 
       if (type(attr_v) == 'table') then attr_v = table.concat(attr_v, ";") 
       elseif (type(attr_v) ~= 'string') then attr_v = tostring(attr_v)
       end
       module.curr_node:attr(attr_n, attr_v) 
   end
end
--[[ change log level not implemented now. absent in requirements
function module.setLevel(level)
    module.logLevel = level
end
function module.getLevel()
    return module.logLevel
end
]]--
function module.finalize()
   module.ndoc:write(module.curr_report_name)	
   if (config.storeFullSDLLogs ~= nil and config.storeFullSDLLogs ~= '') then sdl_log.close() end
end
local function get_script_name(str)
   local tbl =  table.pack(string.match(str, "(.-)([^/]-([^%.]+))$"))
   local name = tbl[#tbl-1]:gsub("%."..tbl[#tbl].."$", "")
   return name
end
function module.init(_name)
   local curr_report_dir = ''
   local curr_sdl_log_dir = ''
   if (module.timestamp == '') then module.timestamp = tostring(os.date('%Y%m%d%H%M%S', os.time())) end
   if (config.reportPath ~= nil and config.reportPath ~= '') then
	    curr_report_dir  = config.reportPath .. '/TestingReports'
        curr_sdl_log_dir = config.reportPath .. '/SDLLogs'
   end

   local curr_report_path = io.catdir(curr_report_dir .."_"..module.timestamp, io.catdir(io.dirname(_name)))
   local curr_log_path = io.catdir(curr_sdl_log_dir .."_"..module.timestamp, io.catdir(io.dirname(_name)))
   if (config.reportMark ~= nil and config.reportMark ~= '' ) then 
        module.full_sdlLog_name = io.catfile(curr_log_path,get_script_name(_name) .."_"..module.timestamp .."_"..config.reportMark .. ".log")
        module.curr_report_name = io.catfile(curr_report_path,get_script_name(_name) .."_"..module.timestamp .."_"..config.reportMark .. ".xml")  
   else
        module.full_sdlLog_name = io.catfile(curr_log_path,get_script_name(_name) .."_"..module.timestamp .. ".log")
        module.curr_report_name = io.catfile(curr_report_path,get_script_name(_name) .."_"..module.timestamp .. ".xml")
   end 
   os.execute("mkdir -p ".. curr_report_path )
  
   module.ndoc = xml.new()
   local alias = _name:gsub('%.', "_"):gsub("/","_")
   module.root = module.ndoc:createRootNode(alias)
   if (config.storeFullSDLLogs ~= nil and config.storeFullSDLLogs ~= '') then 
        os.execute("mkdir -p ".. curr_log_path )
        sdl_log.Connect(sdl_log.init("localhost",4555,module.full_sdlLog_name)) 
   end 

  return module
end

return module
