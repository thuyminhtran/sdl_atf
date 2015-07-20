xml = require("xml")

local doc = xml.open("data/HMI_API.xml")
if not doc then error("Cannot open data/HMI_API.xml") return end

print(string.format("%d interfaces", doc:xpath("count(/interfaces/interface)")))

print("Root node: " .. doc:rootNode():name())

print(string.format("Structures count: %d = %d", #doc:xpath("//struct"), doc:xpath("count(//struct)")))

print("functions having more than two params one of which is 'appID' (intentionally overcomplicated query):")
for k, v in ipairs(doc:xpath("//param[@name='appID']/parent::function[count(param) > 2]")) do
  print(v:parent():attr("name") .. "." .. v:attr("name"))
end

print("The first //param:")
local p = doc:xpath("//param[1]")
print(#p)
print(p[1]:attr("name"), p[1]:attr("type"))

local ndoc = xml.new()
local root = ndoc:createRootNode("test")
for i = 1, 10 do
  local node = root:addChild("hello")
  node:attr("a", i)
  node:text("Hi")
end

x = ndoc:xpath("//hello[last()]")[1]
:text("")
:addChild("bye")
:attr("until", "Friday")
:text("Good luck")

ndoc:write("test.xml")

local f = io.open("test.xml", "r")
s = f:read("*all")
print(s)
f:close()

quit()
