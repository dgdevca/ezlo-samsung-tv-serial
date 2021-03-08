function createConnection(params)
    local storage = require("storage")
    local network = require("network")
    local PLUGIN = storage.get_string("PLUGIN")
    local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/create_connection").setLevel(storage.get_number("log_level") or 99)

    logger.debug("params: %1", params)

    -- pull connection info from storage
    if not storage.exists( "conn" ) then 
        logger.debug("Creating and storing connection...")
        local hndl = network.connect( { ip = storage.get_string("IP"), port = storage.get_string("PORT"), connection_type = "TCP" } )
        network.set_handler( hndl, "HUB:"..PLUGIN.."/scripts/events/network_event" )
        if not hndl then
            logger.error("Failed to connect.")
            return
        else
            logger.info("CONNECTED! Connection is %1", hndl)
            storage.set_number("conn",hndl)
        end
    end
end

createConnection(...)