local utils = require ("cmdutils")
local opts = {}

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


--utils.declare_opt("-c", "--config-file", utils.RequiredArgument, "Config file")
utils.declare_short_opt("-c", utils.RequiredArgument, "Config file")
--utils.declare_long_opt("--config-file", utils.RequiredArgument, "Config file")
--utils.declare_opt("","--mobile-connection", utils.RequiredArgument, "Mobile connection IP")
--utils.declare_opt("-m","", utils.OptionalArgument, "Mobile connection Port")
--utils.declare_opt("-p","", utils.NoArgument, "parallel")
--utils.declare_long_opt("--mobile-connection", utils.RequiredArgument, "Mobile connection IP")
--utils.declare_short_opt("-m", utils.OptionalArgument, "Mobile connection port")
--utils.declare_short_opt("-p", utils.NoArgument, "parallel")
local res = utils.getopt(_G.arg, opts)

print("opts: ".. dump(res.opts))