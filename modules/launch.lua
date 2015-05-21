require ("atf.util")
local script_files = {}


declare_opt("-c", "--config-file", RequiredArgument, "Config file")
declare_long_opt("--mobile-connection", RequiredArgument, "Mobile connection IP")
declare_long_opt("--mobile-connection-port", RequiredArgument, "Mobile connection port")
declare_long_opt("--hmi-connection", RequiredArgument, "HMI connection IP")
declare_long_opt("--hmi-connection-port", RequiredArgument, "HMI connection port")
declare_long_opt("--perflog-connection", RequiredArgument, "PerfLog connection IP")
declare_long_opt("--perflog-connection-port", RequiredArgument, "Perflog connection port")
declare_long_opt("--report-path", RequiredArgument, "Path for a report collecting.")
declare_long_opt("--report-mark", RequiredArgument, "Specify label of string for marking test report.")
declare_long_opt("--store-full-sdl-logs", NoArgument, "Store Full SDL Logs enable")

script_files = parse_cmdl()

if (#script_files > 0) then 
    for _,scpt in ipairs(script_files) do 
	print("==============================")
	print(string.format("Start '%s'",scpt))
	print("==============================")
	dofile(scpt)
    end
end
