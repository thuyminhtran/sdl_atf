local xml = require('xml')
local module = { }

module.classes =
{
  String = { },
  Integer = { },
  Float = { },
  Boolean = { },
  Struct = { },
  Enum = { }
}

module.enum = { }
module.struct = { }

local function loadEnums(api)
  local enums = api:xpath("//interface/enum")
  for _, e in ipairs(enums) do
    local enum = { }
    local i = 1
    for _, item in ipairs(e:children("element")) do
      enum[item:attr("name")] = i
      i = i + 1
    end
    module.enum[e:attr("name")] = enum
  end
end

local function loadStructs(api)
  local structs = api:xpath("//interface/struct")
  for _, s in ipairs(structs) do
    local struct = { }
    for _, item in ipairs(s:children("param")) do
      struct[item:attr("name")] = item:attributes()
    end
    module.struct[s:attr("name")] = struct
  end

    for n, s in pairs(module.struct) do
      for _, p in pairs(s) do
        if type(p.type) == 'string' then
          if p.type == "Integer" then
            p.class = module.classes.Integer
          elseif p.type == "String" then
            p.class = module.classes.String
          elseif p.type == "Float" then
            p.class = module.classes.Float
          elseif p.type == "Boolean" then
            p.class = module.classes.Boolean
          elseif module.enum[p.type] then
            p.class = module.classes.Enum
            p.type = module.enum[p.type]
          elseif module.struct[p.type] then
            p.class = module.classes.Struct
            p.type = module.struct[p.type]
          end
        end
      end
    end
end

function module.init(path)
  local _api = xml.open(path)
  if not _api then error(path .. " not found") end

  loadEnums(_api)
  loadStructs(_api)
  return module
end  

return module
