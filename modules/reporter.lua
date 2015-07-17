local xml     = require('xml')
local io      = require('atf.stdlib.std.io')
local sdl_log = require('sdl_logger')
local atf_log = require('atf_logger')
local ford_constants = require("protocol_handler/ford_protocol_constants")

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


local escape_lua_pattern
do
  local matches =
  {
    ["'"] = "%'";
    ["#"] = "";
    ["&"] = "";
 }

    escape_lua_pattern = function(s)
        return (s:gsub(".", matches))
     end
end


local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '\''..k..'\'' end
         s = s .. '['..k..'] = \'' .. dump(v) .. '\','
      end
      return s .. '}'
   elseif string.match(tostring(o),'[%Wxyz]') then
      return escape_lua_pattern(tostring(o))
   end
  return tostring(o)
end
function module.AddCase(name)
   if(not config.excludeReport) then
       module.curr_node = module.root:addChild(name)
       module.ndoc:write(module.curr_report_name)
   end
end
function module.AddMessage(name,funcName,...)
   if(not config.excludeReport) then
       local attrib = table.pack(...)[1]
       local msg =  module.curr_node:addChild(name)

       if (type(funcName) ~= 'table') then
            msg:attr('FunctionName',funcName)
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
       module.ndoc:write(module.curr_report_name)
  end
end
function module.CaseMessageTotal(name, ... )
  if(not config.excludeReport) then
      local attrib = table.pack(...)[1]
      for attr_n,attr_v in pairs(attrib) do
          if (type(attr_v) == 'table') then attr_v = table.concat(attr_v, ';')
          elseif (type(attr_v) ~= 'string') then attr_v = tostring(attr_v)
          end
          module.curr_node:attr(attr_n, attr_v)
      end
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
   if(not config.excludeReport) then
       module.ndoc:write(module.curr_report_name)
       if (config.storeFullSDLLogs) then sdl_log.close() end
   end
end
local function get_script_name(str)
   local tbl =  table.pack(string.match(str, '(.-)([^/]-([^%.]+))$'))
   local name = tbl[#tbl-1]:gsub('%.'..tbl[#tbl]..'$', '')
   return name
end
function module.init(_name)
   if(config.excludeReport) then return module end
   local dir_name = './' .. _name
   local curr_report_dir = ''
   local curr_sdl_log_dir = ''
   if (module.timestamp == '') then module.timestamp = tostring(os.date('%Y%m%d%H%M%S', os.time())) end
   if (config.reportPath ~= nil and config.reportPath ~= '') then
        curr_report_dir  = config.reportPath .. '/TestingReports'
        curr_sdl_log_dir = config.reportPath .. '/SDLLogs'
   else
        curr_report_dir  = 'TestingReports'
        curr_sdl_log_dir = 'SDLLogs'
   end

   local curr_report_path = io.catdir(curr_report_dir ..'_'..module.timestamp, io.catdir(io.dirname(dir_name)))
   local curr_log_path = io.catdir(curr_sdl_log_dir ..'_'..module.timestamp, io.catdir(io.dirname(dir_name)))
   if (config.reportMark ~= nil and config.reportMark ~= '' ) then
        module.full_sdlLog_name = io.catfile(curr_log_path,get_script_name(dir_name) ..'_'..module.timestamp ..'_'..config.reportMark .. '.log')
        module.full_atf_log_name = io.catfile(curr_log_path,get_script_name(dir_name) ..'_'..module.timestamp ..'_'..config.reportMark .. '_full.txt')
        module.atf_log_name = io.catfile(curr_log_path,get_script_name(dir_name) ..'_'..module.timestamp ..'_'..config.reportMark .. '.txt')

        module.curr_report_name = io.catfile(curr_report_path,get_script_name(dir_name) ..'_'..module.timestamp ..'_'..config.reportMark .. '.xml')
   else
        module.full_atf_log_name = io.catfile(curr_log_path,get_script_name(dir_name) ..'_'..module.timestamp ..'_'..'full.txt')
        module.atf_log_name = io.catfile(curr_log_path,get_script_name(dir_name) ..'_'..module.timestamp ..'.txt')
        module.full_sdlLog_name = io.catfile(curr_log_path,get_script_name(dir_name) ..'_'..module.timestamp .. '.log')
        module.curr_report_name = io.catfile(curr_report_path,get_script_name(dir_name) ..'_'..module.timestamp .. '.xml')
   end
   os.execute('mkdir -p "'.. curr_report_path .. '"')

   module.ndoc = xml.new()
   local alias = _name:gsub('%.', '_'):gsub('/','_')
   module.root = module.ndoc:createRootNode(alias)
   if (config.storeFullSDLLogs) then
        os.execute('mkdir -p "'.. curr_log_path .. '"')
        sdl_log.Connect(sdl_log.init(config.sdl_logs_host, config.sdl_logs_port, module.full_sdlLog_name))
   end
   module.full_atf_log = atf_log:New(module.full_atf_log_name)
   module.atf_log = atf_log:New(module.atf_log_name)
  return module
end

function module:LOG(tract, message)
 	module.full_atf_log[tract](module.full_atf_log, message)
    if string.find(tract, "HMI") or message.frameType ~= ford_constants.FRAME_TYPE.CONTROL_FRAME then
		module.atf_log[tract](module.atf_log, message)
	end
end

return module
