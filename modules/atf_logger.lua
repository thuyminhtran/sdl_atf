local json = require("json")
local LoggerMeta = {}
function time()
	return os.time()
end

function LoggerMeta:MOBtoSDL(message)
	log_str = string.format("MOB->SDL(%s) [version: %s, frameType: %s, encryption: %s, serviceType: %s, frameInfo: %s, messageID: %s] : %s ", time(), message["varsion"], message["frameType"], message["encryption"], message["serviceType"], message["frameInfo"], message["messageID"], message["payload"])
	self.atf_log_file:write(log_str)
end

function LoggerMeta:SDLtoMOB(message)
	log_str = string.format("MOB->SDL(%s) [version: %s, frameType: %s, encryption: %s, serviceType: %s, frameInfo: %s, messageID: %s] : %s ", time(), message["varsion"], message["frameType"], message["encryption"], message["serviceType"], message["frameInfo"], message["messageID"], message["payload"])
	self.atf_log_file:write(log_str)
end

function LoggerMeta:HMItoMOB(mesage)
	log_str = string.format("MOB->SDL(%s) [version: %s, frameType: %s, encryption: %s, serviceType: %s, frameInfo: %s, messageID: %s] : %s ", time(), message["varsion"], message["frameType"], message["encryption"], message["serviceType"], message["frameInfo"], message["messageID"], message["payload"])
	self.atf_log_file:write(log_str)
end

function LoggerMeta:SDLtoHMI(message)
	log_str = string.format("MOB->SDL(%s) [version: %s, frameType: %s, encryption: %s, serviceType: %s, frameInfo: %s, messageID: %s] : %s ", time(), message["varsion"], message["frameType"], message["encryption"], message["serviceType"], message["frameInfo"], message["messageID"], message["payload"])
	self.atf_log_file:write(log_str)
end


function LoggerMeta:New(path_to_log_file)
	local logger = { mt = { __index = LoggerMeta}}
	logger.atf_log_file = io.open(path_to_log_file, "w+")
	setmetatable(logger, logger.mt)
	return logger
end


