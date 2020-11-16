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
                local data = network.receive( hndl )
                logger.debug("IN: %1", StringOfByteValues(data))
            elseif io_activity_type == "OUT" then
                logger.debug("OUT")
                print("samsung-tv-serial: OUT")
                --doesn't ever run??
            end
        end
    end
end