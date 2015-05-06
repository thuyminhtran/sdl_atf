local utils = require ("atf.cmdutils")
arguments = {}

utils.declare_opt("-c", "--config-file", utils.RequiredArgument, "Config file")
--utils.declare_opt("-c", "--config-file", utils.OptionArgument, "Config file")
--utils.declare_opt("-f", "--file", utils.OptionalArgument, "Config file")
utils.declare_long_opt("--mobile-connection", utils.RequiredArgument, "Mobile connection IP")
utils.declare_long_opt("--mobile-connection-port", utils.RequiredArgument, "Mobile connection port")
utils.declare_long_opt("--hmi-connection", utils.RequiredArgument, "HMI connection IP")
utils.declare_long_opt("--hmi-connection-port", utils.RequiredArgument, "HMI connection port")
utils.declare_long_opt("--perflog-connection", utils.RequiredArgument, "PerfLog connection IP")
utils.declare_long_opt("--perflog-connection-port", utils.RequiredArgument, "Perflog connection port")
utils.declare_long_opt("--report-path", utils.RequiredArgument, "Path for a report collecting.")
utils.declare_long_opt("--report-mark", utils.RequiredArgument, "Specify label of string for marking test report.")


function config_file(config)
    print("Config file: ".. config)
end
function mobile_connection(str)
    print("Mobile Connection String: ".. src)
end
function mobile_connection_port(src)
    print("Mobile Connection port: ".. src)
end
function hmi_connection(str)
    print("HMI connection string: ".. str)
end
function hmi_connection_port(src)
    print("HMI Connection port: ".. src)
end
function perflog_connection(str)
    print("PerfLog connection string: ".. str)
end
function perflog_connection_port(str)
    print("PerfLog connection port: ".. str)
end
function report_path(src)
    print("Report Path: ".. src)
end
function report_mark(src)
    print("Report mark: ".. src)
end
function test_keys(src)
    print("Test file: ".. src)
end


d = qt.dynamic()
function d.cmd_test()
    arguments = utils.getopt(argv, opts)
    for k,v in pairs(arguments) do
	if type(k) ~= 'number' then
	    k = (k):match ("^%-*(.*)$"):gsub ("%W", "_")
	    _G[k](v)
	else
	    if k >= 2 and v ~= "test/cmd_test.lua" then
    	    test_keys(v)
	    end
	end 
    end
--	utils.PrintUsage()

    quit()
end


d:cmd_test()
