local json = require("json")
local Logger = {}
function time()
	return os.time()
end

function Logger:MOBtoSDL(message)
	log_str = string.format("MOB->SDL(%s) [version: %s, frameType: %s, encryption: %s, serviceType: %s, frameInfo: %s, messageID: %s] : %s ", time(), message["varsion"], message["frameType"], message["encryption"], message["serviceType"], message["frameInfo"], message["messageID"], message["payload"])
	self.atf_log_file:write(log_str)
end

function Logger:SDLtoMOB(message)
	log_str = string.format("MOB->SDL(%s) [version: %s, frameType: %s, encryption: %s, serviceType: %s, frameInfo: %s, messageID: %s] : %s ", time(), message["varsion"], message["frameType"], message["encryption"], message["serviceType"], message["frameInfo"], message["messageID"], message["payload"])
	self.atf_log_file:write(log_str)
end

function Logger:HMItoMOB(mesage)
	log_str = string.format("MOB->SDL(%s) [version: %s, frameType: %s, encryption: %s, serviceType: %s, frameInfo: %s, messageID: %s] : %s ", time(), message["varsion"], message["frameType"], message["encryption"], message["serviceType"], message["frameInfo"], message["messageID"], message["payload"])
	self.atf_log_file:write(log_str)
end

function Logger:SDLtoHMI(message)
	log_str = string.format("MOB->SDL(%s) [version: %s, frameType: %s, encryption: %s, serviceType: %s, frameInfo: %s, messageID: %s] : %s ", time(), message["varsion"], message["frameType"], message["encryption"], message["serviceType"], message["frameInfo"], message["messageID"], message["payload"])
	self.atf_log_file:write(log_str)
end


function Logger:New(path_to_log_file)
	local logger = { mt = { __index = Logger}}
	logger.atf_log_file = io.open(path_to_log_file, "w+")
	setmetatable(logger, logger.mt)
	return logger
end


