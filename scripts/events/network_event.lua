local params = ... or {}

local storage = require("storage")
local network = require("network")
local PLUGIN = storage.get_string("PLUGIN")
local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/network_event").setLevel(storage.get_number("log_level") or 99)

function StringOfByteValues(data)
    local tbl = {string.byte(data, 1, #data)}
    for i = 1, #tbl do
        tbl[i] = string.format("0x%02X", tbl[i])
    end
    return table.concat(tbl,", ")
end

if params.event then
    if params.event == "network" then
        local data = params.data
        if data.event_type == "io_activity" then
            local io_activity_type = data.event.io_activity_type
            local hndl = data.event.handle
            if io_activity_type == "CONNECTED" then
                logger.info("CONNECTED")
            elseif io_activity_type == "FAILED_TO_CONNECT" then
                logger.warn("FAILED_TO_CONNECT")
            elseif io_activity_type == "IN" then
                --need to inspect the data buffer for a command ack
                local data = ""
                local i = ""  -- start index
                local j = ""  -- end index
                
                data = network.inspect_data( hndl )
                size = network.inspect_data_size( hndl )
                logger.debug("BUFFER (bytes): %1", StringOfByteValues(data))
                logger.debug("BUFFER: %1", data)    

                if string.find( data, "\x03\x0C\xF1" ) then -- COMMAND ACK: 0x03, 0x0C, 0xF1
                    i, j = string.find(data, "\x03\x0C\xF1")
                    logger.debug("Command ACK")
                    data = network.receive( hndl, j )
                    logger.debug("IN: %1", StringOfByteValues(data))    
                elseif size >= 3 then
                    -- No defined end of line / command, so process and empty buffer. 
                    -- Noise is mostly from the POWER ON command. Afterwards, TV only sends Command ACK responses.
                    data = network.receive( hndl, j )
                    logger.debug("IN: %1", StringOfByteValues(data))
                end
            elseif io_activity_type == "OUT" then
                logger.debug("OUT")
                print("samsung-tv-serial: OUT")
            end
        end
    end
end