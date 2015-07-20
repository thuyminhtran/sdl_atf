xmlReporter = require("reporter")
config = require("config")

local sdl_log = require('sdl_logger')
local io = require("atf.stdlib.std.io")

function FindDirectory(directory,currDate)
  local t, popen = "", io.popen
  for filename in popen('ls -a "'..directory..'"'):lines() do
    if string.find(filename,"SDLLogs_"..currDate,1,true) ~=nil then
      t= filename
    end
  end
  return t
end

function FindReportPath(ReportPath)
  filereport = assert(io.open(ReportPath,"r"))

  if filereport == nil then
    print("ERROR: Directory was not found. Possibly problem in date, look there")
  else
    print("Directory was successfully found")
  end

  filereport:close()
end

function FindReport(ReportPath, reporter_name, currDate)

  local t, popen = "", io.popen
  for reportName in popen('ls -a "'..ReportPath..'"'):lines() do
    if string.find(reportName, reporter_name.."_"..currDate,1,true) ~=nil then
      t= reportName
      print("SDL log file was successfully found")
    end
  end
  if t == "" then
    print("ERROR: SDL log file does not exist")
  end
  return t
end

--=================================
print ("Sdl Logger test started")
print("==============\n")

dates = os.date("%Y%m%d%H%M")

ReportPath = FindDirectory("./Testing Reports/",dates)
ReportPath = "Testing Reports/".. ReportPath.."/test"

FindReportPath(ReportPath)

reporter_name = "SDLLogTest"
ReportName = FindReport(ReportPath, reporter_name, dates)

print("============== \n")
print ("Test ended")
quit()
