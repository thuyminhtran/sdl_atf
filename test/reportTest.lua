xmlLogger = require("logger")
config    = require("config")
local io  = require("atf.stdlib.std.io")
function FindDirectory(directory,currDate)
    local t, popen = "", io.popen
    for filename in popen('ls -a "'..directory..'"'):lines() do
    	if string.find(filename,"TestingReports_"..currDate,1,true) ~=nil then
      	  t= filename
   		end
    end
    return t
end


function  FindReportPath(ReportPath)
	filereport = assert(io.open(ReportPath,"r"))

	if filereport == nil then 
		print("ERROR: Directory \"Testing Reports\" was not found")
	else 
		print("Directory  \"Testing Reports\" was successfully found")
	end

	filereport:close()
end

function  FindReport(ReportPath, xmlName, currDate)

	 local t, popen = "", io.popen
    for reportName in popen('ls -a "'..ReportPath..'"'):lines() do
    	if string.find(reportName,xmlName.."_"..currDate,1,true) ~=nil then
      	  t= reportName
      	  print("Xml report file was successfully found")         	  
   		end
    end
    if t == "" then
	    print("ERROR: Xml report file does not exist")
	end
    return t
end

function cleanTestDirectory(ReportPath,ReportName)
	res, err  = os.remove(ReportName)
	if not res then
		print(err)
	else 
		print("Test report "..ReportName.. " was successfully deleted")
	end

end

function createXmlFile(xmlname)
	 xmlLogger.init(tostring("test/"..xmlname))
	 xmlLogger.AddCase("InitHMI")	
	 xmlLogger.CaseMessageTotal(xmlLogger.current_case_name,{ ["result"] = "success", ["timestamp"] ="100"} )
	 xmlLogger.AddMessage("EXPECT_HMIEVENT", {["FunctionName"] = "Connected websocket"})
	 xmlLogger.AddMessage("hmi_connection", {["FunctionName"] = "SendRequest"},"{[\"methodName\"] = \"New method\"}")
	 xmlLogger:finalize()
end

function AnalyzeXmlReport(ReportPath,ReportName)
	filereport = assert(io.open(ReportPath.."/"..ReportName,"r"))

    line = filereport:read()  
    if line == nil then 
		print ("ERROR: unexpected end of xml file") 
		return 
	end  	
	line = filereport:read()  
	if line == nil then 
		print ("ERROR: unexpected end of xml file") 
		return 
	end  
	if line ~= "<test_validationTest_lua>" then 
		print("ERROR: incorrect case, get "..line)
	end
	line = filereport:read()  
	if line == nil then 
		print ("ERROR: unexpected end of xml file") 
		return 
	end
	result =string.find(line,"result=\"success\"",1,true)
	if result == nil then 
		print("ERROR: incorrect result")
	end
	result =string.find(line,"timestamp=\"100\"",1,true)
	if result == nil then 
		print("ERROR: incorrect timestamp, get " .. line)
	end
	line = filereport:read()
	if line == nil then 
		print ("ERROR: unexpected end of xml file") 
		return 
	end  
	result =string.find(line,"<EXPECT_HMIEVENT FunctionName=\"Connected websocket\"/>",1,true)
	if result == nil then 
		print("ERROR: incorrect parameter line, get "..line)
	end

	line = filereport:read()
	if line == nil then 
		print ("ERROR: unexpected end of xml file") 
		return 
	end  
	result =string.find(line,"<hmi_connection FunctionName=\"SendRequest\">{[\"methodName\"] = \"New method\"}</hmi_connection>",1,true)
	if result == nil then 
		print("ERROR: incorrect parameter line with arguments, get "..line)
	end

	line = filereport:read()
	if line == nil then 
		print ("ERROR: unexpected end of xml file") 
		return 
	end  
	result =string.find(line,"</InitHMI>",1,true)
	if result == nil then 
		print("ERROR: expected close bracket of test case")
	end

	line = filereport:read()
	if line == nil then 
		print ("ERROR: unexpected end of xml file") 
		return 
	end  
	if line ~= "</test_validationTest_lua>" then 
		print("ERROR: expected close bracket of main test part")		
	end
   
    print ("Analyze finished")

	filereport:close()
end


--=================================
print ("Report test started")
print("==============\n")

dates = os.date("%Y%m%d%H%M")

xmlname = "validationTest.lua"
createXmlFile(xmlname)

ReportPath = FindDirectory("./Testing Reports/",dates)

ReportPath = "Testing Reports/".. ReportPath.."/test"

FindReportPath(ReportPath)

xmlname = "validationTest"
ReportName = FindReport(ReportPath,xmlname,dates)
if ReportName ~= "" then 
	AnalyzeXmlReport(ReportPath,ReportName)
end
print("============== \n")
print ("Test ended")
quit()