local utils = require ("atf.cmdutils")

utils.declare_opt("-c", "--config-file", utils.RequiredArgument, "Config file")
utils.declare_opt("","--mobile-connection", utils.RequiredArgument, "Mobile connection IP")
utils.declare_long_opt("--hmi-connection", utils.RequiredArgument, "HMI connection IP")

d = qt.dynamic()
function d.cmd_test()
    arguments = utils.getopt(argv, opts)
    if arguments["config-file"] then
	print("Config file: ".. arguments["config-file"])
    else
	utils.PrintUsage()
    end
    quit()
end


d:cmd_test()