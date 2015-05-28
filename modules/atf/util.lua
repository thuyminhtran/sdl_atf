local utils = require("atf.stdlib.argument_parser")
config = require('config')
xmlLogger = require("logger")

local module = { }
local script_files = {}

RequiredArgument = utils.RequiredArgument
OptionalArgument = utils.OptionalArgument
NoArgument       = utils.NoArgument


local function file_exists(name)
	if io.open(name,"r") ~=nil then io.close(f) return true else return false end
end

function module.config_file(config_file)
	if (file_exists(config_file)) then
	    config_file = config_file:gsub('%.', " ")
	    config_file = config_file:gsub("/", ".")
	    config_file = config_file:gsub("[%s]lua$", "")
        config = require(tostring(config_file))
	else
    	print("Incorrect config file type")
    	print("Uses default config")
    	print("==========================")
	end
end
function module.mobile_connection(str)
	config.mobileHost = str
end
function module.mobile_connection_port(src)
	config.mobilePort= src
end
function module.hmi_connection(str)
	config.hmiUrl = str
end
function module.hmi_connection_port(src)
	config.hmiPort = src
end
function module.perflog_connection(str)
	config.perflogConnection=str
end
function module.perflog_connection_port(str)
	config.perflogConnectionPort=str
end
function module.report_path(str)
	config.reportPath=str
end
function module.report_mark(str)
	config.reportMark=str
end
function module.add_script(src)
  table.insert(script_files,src)
end
function module.storeFullSDLLogs(str)
	config.storeFullSDLLogs=str
end
function module.heartbeat(str)
	config.heartbeatTimeout=str
end
function parse_cmdl()
    arguments = utils.getopt(argv, opts)
	if (arguments) then
	    if (arguments['config-file']) then module.config_file(arguments['config-file']) end
	        for k,v in pairs(arguments) do
	            if (type(k) ~= 'number') then
	                if ( k ~= 'config-file') then
	                    k = (k):match ("^%-*(.*)$"):gsub ("%W", "_")
                        module[k](v)
		            end
		       else
	                if k >= 2 and v ~= "modules/launch.lua" then
		                module.add_script(v)
		            end
		       end
		    end
		end
        return script_files
end
function PrintUsage()
	utils.PrintUsage()
end
function declare_opt(...)
	utils.declare_opt(...)
end
function declare_long_opt(...)
	utils.declare_long_opt(...)
end
function declare_short_opt(...)
	utils.declare_short_opt(...)
end
function split_script_name(str)
	return table.pack(string.match(str, "(.-)([^/]-([^%.]+))$"))
end
function script_execute(script_name)
	xmlLogger = xmlLogger.init(tostring(script_name))
  dofile(script_name)
end
function compareValues(a, b, name)
    local function iter(a, b, name, msg)
        if type(a) == 'table' and type(b) == 'table' then
            local res = true
            for k, v in pairs(a) do
                res = res and iter(v, b[k], name .. "." .. k, msg)
            end
            return res
        else
            if a == b then
                return true
            else
                table.insert(msg, string.format("%s: expected: %s, actual value: %s", name, a, b))
                return false
            end
        end
    end
  local message = { }
  local res = iter(a, b, name, message)
  return res, table.concat(message, '\n')
end
