#ATF components overview
This  documents provide short descriptions of main ATF components.
Components diagram can be found on https://adc.luxoft.com/confluence/display/APPLINK/ATF+component+view 

## Qt Core
Qt Core runs lua core.
Qt core contains common utils functions like:

- timer
- signal/slot system 
- XML parsing
- Web-Sockets

## Lua core

Lua core contains main functionality of ATF.

### Utils

Contains common utils used in ATF like

- json encoder/decoder
- console output formater
- arguments parser 

### Reporters

Contains components for ATF output reports. There 3 main ATF outputs

#### SDL logger

Grabs SDL log via telnet and save it to corresponding directory. 
*Plain text format*

#### ATF logger 

Grabs all transport data, parse according ford protocol and save to simplify analyzing transferred data.
*Plain text format*

#### XML reporter

Provide reports of ATF scripts execution contains all received and expected requests, information about fails to analyze it. 
*XML format*

### Config

Contains configurable data for ATF run.
*Lua script format" 

### Launcher

Contains logic run and stop SDL it use lua script to handle SDL state during scripts execution and bash scripts to run and stop SDL.

### Transport

Components used to provide specific transport in ATF

#### TCP connection

Provide ability to connect to remote host and transfer TCP data.

#### Web-socket connection

Provide ability to connect to remote host and transfer web-socket data.

#### HMI connection 

Use web-socket connection to transfer json requests/responses


### Mobile Connection

Implements logic of receiving/sending mobile requests/responses 

#### File connection

Used as socket abstraction for mobile connection to prevent  memory overflow.
This component writes to file system all data that it received. And write to socket when socket is ready.

#### Mobile Session 

Implements all session logic:
- Requests/responses handling
- Heart beet
- Session multiplexing
- Open/close session

### Validation

This components use HMI and mobile API to validate input and output data.

### Event engine

Provide functionality for basic event engine and common expectation

### Protocol handler 

Used to validate and parse mobile data on protocol layer. Used by mobile connection. 






