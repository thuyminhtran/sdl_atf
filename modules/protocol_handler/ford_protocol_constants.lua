--- Module which provides constants for the protocol
--
-- *Dependencies:* none
--
-- *Globals:* none
-- @module protocol_handler.ford_protocol_constants
-- @copyright [Ford Motor Company](https://smartdevicelink.com/partners/ford/) and [SmartDeviceLink Consortium](https://smartdevicelink.com/consortium/)
-- @license <https://github.com/smartdevicelink/sdl_core/blob/master/LICENSE>

local SDLProtocolConstants = {}

--- Protocol header size for each frame
SDLProtocolConstants.PROTOCOL_HEADER_SIZE = 12

--- Binary header size for each frame
SDLProtocolConstants.BINARY_HEADER_SIZE = 12

--- Maximum size of frame for each protocol version
SDLProtocolConstants.FRAME_SIZE = {
  P1 = 1500,
  P2 = 1500,
  P3 = 1500,
  P4 = 1500
}

--- Frame type enumeration
SDLProtocolConstants.FRAME_TYPE = {
  CONTROL_FRAME = 0x00,
  SINGLE_FRAME = 0x01,
  FIRST_FRAME = 0x02,
  CONSECUTIVE_FRAME = 0x03,
}
--- Service type enumeration
SDLProtocolConstants.SERVICE_TYPE = {
  CONTROL = 0x00,
  PCM = 0x0A,
  VIDEO = 0x0B,
  BULK_DATA = 0x0F,
  RPC = 0x07,
}
--- Frame info enumeration
SDLProtocolConstants.FRAME_INFO = {
  HEARTBEAT = 0x00,
  LAST_FRAME = 0x00,
  START_SERVICE = 0x01,
  START_SERVICE_ACK = 0x02,
  START_SERVICE_NACK = 0x03,
  END_SERVICE = 0x04,
  END_SERVICE_ACK = 0x05,
  END_SERVICE_NACK = 0x06,
  SERVICE_DATA_ACK = 0xFE,
  HEARTBEAT_ACK = 0xFF
}

--- RPC type for Binary header
SDLProtocolConstants.BINARY_RPC_TYPE = {
  REQUEST = 0x0,
  RESPONSE = 0x1,
  NOTIFICATION = 0x2
}

--- RPC Function Id for Binary header
SDLProtocolConstants.BINARY_RPC_FUNCTION_ID = {
  HANDSHAKE = 0x1,
}
return SDLProtocolConstants
