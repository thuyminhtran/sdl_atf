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

local hmi_api = xml.open("data/HMI_API.xml")
if not hmi_api then error("HMI_API.xml not found") end

function loadEnums(api)
  local enums = api:xpath("/interfaces/interface/enum")
  for _, e in ipairs(enums) do
    local enum = { }
    local i = 1
    for _, item in ipairs(e:children("element")) do
      enum[item:attr("name")] = i
      i = i + 1
    end
--    print(e:parent():attr("name") .. "." .. e:attr("name"))
--    module.enum[e:parent():attr("name") .. "." .. e:attr("name")] = enum
    module.enum[e:attr("name")] = enum
  end
end

function loadStructs(api)
  local structs = api:xpath("/interfaces/interface/struct")
  for _, s in ipairs(structs) do
    local struct = { }
    for _, item in ipairs(s:children("param")) do
      struct[item:attr("name")] = item:attributes()
    end
--    module.struct[s:parent():attr("name") .. "." .. s:attr("name")] = struct
    module.struct[s:attr("name")] = struct
  end

--  while true do
--    local has_unresolved = false
    local unresolved = ""
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
          else
--            has_unresolved = true
            unresolved = p.type
          end
        end
      end
    end
--    if not has_unresolved then break end
--  end
end

loadEnums(hmi_api)
loadStructs(hmi_api)

return module
