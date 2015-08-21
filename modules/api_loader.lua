local xml = require('xml')
local module = { }

local function loadEnums(api, dest)
  local enums = api:xpath("//interface/enum")
  for _, e in ipairs(enums) do
    local enum = { }
    local i = 1
    for _, item in ipairs(e:children("element")) do
      enum[item:attr("name")] = i
      i = i + 1
    end
    dest.enum[e:attr("name")] = enum
  end
end

local function loadStructs(api, dest)
  local structs = api:xpath("//interface/struct")
  for _, s in ipairs(structs) do
    local struct = { }
    for _, item in ipairs(s:children("param")) do
      struct[item:attr("name")] = item:attributes()
    end
    dest.struct[s:attr("name")] = struct
  end

  for n, s in pairs(dest.struct) do
    for _, p in pairs(s) do
      if type(p.type) == 'string' then
        if p.type == "Integer" then
          p.class =dest.classes.Integer
        elseif p.type == "String" then
          p.class = dest.classes.String
        elseif p.type == "Float" then
          p.class = dest.classes.Float
        elseif p.type == "Boolean" then
          p.class = dest.classes.Boolean
        elseif dest.enum[p.type] then
          p.class = dest.classes.Enum
          p.type = dest.enum[p.type]
        elseif dest.struct[p.type] then
          p.class = dest.classes.Struct
          p.type = dest.struct[p.type]
        end
      end
    end
  end
end

function module.init(path)
  local result={}
  result.classes =
  {
     String = { },
     Integer = { },
     Float = { },
     Boolean = { },
     Struct = { },
     Enum = { }
  }
  result.enum = { }
  result.struct = { }

  local _api = xml.open(path)
  if not _api then error(path .. " not found") end

  loadEnums(_api, result)
  loadStructs(_api, result)
  return result
end

return module
