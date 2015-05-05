local std = require "atf.stdlib.std"
local table = require "atf.stdlib.std.table"

local validOptList = {  }  
local errors = {}

local usage = [[
   ATF 2.2

   Usage: atf script.lua [OPTIONS]
   
   ]]

local help = {}

local fotter = [[
-v,--version          display version information, then exit
   -h,--help             display this help, then exit   
   ]]

local version = "ATF 2.2"   
   
local optparser = std.optparse [[
   ATF 2.2
   Additional lines of text to show when the --version
   option is passed.

   Several lines or paragraphs are permitted.

   Usage: atf script.lua  [OPTIONS]  
   ]]

local module = { 
                mt = { __index = { } } , 
                RequiredArgument = 1,
                OptionalArgument = 2,
                NoArgument = 3
              }
   

local function errmsg (msg)
    local prog = "ATF"
    -- Ensure final period.
    if msg:match ("%.$") == nil then msg = msg .. "." end
    io.stderr:write (prog .. ": error: " .. msg .. "\n")
    io.stderr:write (prog .. ": Try '" .. prog .. " --help' for help.\n")
--    os.exit (2)
end

local function checkReqOpt(self, arg, val)
  if val:sub (1, 2) == "--" then
     errmsg ("Not correct argument '" .. val .. "' for key '" .. arg .. "'")
  else
     validOptList[self[arg].key] = val
  end     
end  


function module.getopt(argv, opts)
  local res = {}
  if (argv[1] == nil) then module.PrintUsage() end
  
  optparser:on ({"-?"}, optparser.optional,module.PrintUsage)      
  optparser:on ({"-h","--help"}, optparser.optional,module.PrintUsage)      
  optparser:on ({"-v","--version"}, optparser.optional,module.PrintVersion)          
  
  local function parse(argv)
      return optparser:parse (argv)
  end 

  local script,options = parse(argv) 
  
  if (script[1]:sub(1,1)~= "-") then
      res = table.merge(validOptList, options)
      for i = 1 , #script do
        local n = table.size(res)
        res[n+1] = script[i]
      end
  else
     res = "undefined option: '" .. script[1] .. "'"
  end
  
  setmetatable(res, module.mt)
  
  return res
end
function module.declare_opt (shortname, longname, argument, description)
local arg = ''  
    if argument == module.RequiredArgument then 
        optparser:on (table.pack(shortname, longname), optparser.required,checkReqOpt)       
    elseif  argument == module.OptionalArgument then
        optparser:on (table.pack(shortname, longname), optparser.optional)        
    else
        optparser:on (table.pack(shortname, longname), optparser.flag)        
    end
    arg = string.format("   %s", description or 'value')
    table.insert(help, shortname .. longname .. arg  )
end
function module.declare_short_opt(shortname, argument, description)
    module.declare_opt (shortname, '' , argument, description)
end
function module.declare_long_opt(longname, argument, description)
    module.declare_opt('' ,longname , argument, description)
end
function module.PrintUsage()
    local _usage = usage
     for _, opt in ipairs(help) do
      _usage = _usage ..  opt .. '\n' .. '   '
     end
     
    _usage = _usage .. '\n' ..'   ' .. fotter
   print(_usage)
  os.exit (2)   
end
function module.PrintVersion()
  print(version)
end

return module