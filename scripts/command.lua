
local function command(params)
    local storage = require("storage")
    local network = require("network")
    local PLUGIN = storage.get_string("PLUGIN")
    local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/command").setLevel(storage.get_number("log_level") or 99)

    logger.debug("params: %1", params)

    -- pull connection info from storage
    if not storage.exists( "conn" ) then 
        logger.debug("Creating and storing connection...")
        local hndl = network.connect( { ip = "10.50.14.8", port = "2001", connection_type = "TCP" } )
        network.set_handler( hndl, "HUB:"..PLUGIN.."/scripts/events/network_event" )
        if not hndl then
            logger.error("Failed to connect.")
            return
        else
            logger.info("CONNECTED! Connection is %1", hndl)
            storage.set_number("conn",hndl)
        end
    end

    hndl = storage.get_number("conn")
    --network.set_handler( hndl, "HUB:"..PLUGIN.."/scripts/events/network_event" )
    logger.debug("hndl: %1", hndl)

    local command = ""
    local action = ""

    -- Basic start of command processing logic...
    if params.power == "ON" then
        action = {0x00, 0x00, 0x00, 0x02}
    elseif params.power == "OFF" then
        action = {0x00, 0x00, 0x00, 0x01}
    else
        logger.warn("Unknown command: %1", params.power)
        return
    end

    checksum = 0xFF - (0x08 + 0x22 + action[1] + action[2] + action[3] + action[4]) + 1
    command = string.char(0x08,0x22,action[1],action[2],action[3],action[4],checksum)
    network.send(hndl, command)
end

command(...)
