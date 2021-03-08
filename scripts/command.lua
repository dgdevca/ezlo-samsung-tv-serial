local function command(params)
    local storage = require("storage")
    local network = require("network")
    local PLUGIN = storage.get_string("PLUGIN")
    local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/command").setLevel(storage.get_number("log_level") or 99)

    logger.debug("params: %1", params)

    -- pull connection info from storage
    if not storage.exists( "conn" ) then 
        logger.debug("Connection doesn't exist - error!")
    else
        hndl = storage.get_number("conn")
        logger.debug("hndl: %1", hndl)
    
        local command = ""
        local action = ""
    
        -- Basic start of command processing logic...
        if params.power == "ON" then
            action = {0x00, 0x00, 0x00, 0x02}
        elseif params.power == "OFF" then
            action = {0x00, 0x00, 0x00, 0x01}
        elseif params.volume == "UP" then
            action = {0x01, 0x00, 0x01, 0x00}
        elseif params.volume == "DOWN" then
            action = {0x01, 0x00, 0x02, 0x00}
        elseif params.volume == "MUTE" then
            action = {0x02, 0x00, 0x00, 0x00}
        else
            logger.warn("Unknown command: %1", params)
            return
        end
    
        checksum = 0xFF - (0x08 + 0x22 + action[1] + action[2] + action[3] + action[4]) + 1
        command = string.char(0x08,0x22,action[1],action[2],action[3],action[4],checksum)
        network.send(hndl, command)
    end
end

command(...)
