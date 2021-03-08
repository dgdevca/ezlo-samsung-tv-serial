local storage = require("storage")

if storage.get_string("PLUGIN") == nil then
    -- First run, create storage objects we needed.
    storage.set_string("PLUGIN", "samsung-tv-serial")
end

-- start logging
local PLUGIN = storage.get_string("PLUGIN")
local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/startup").setLevel(storage.get_number("log_level") or 99)

-- delete any previous connections
if storage.exists( "conn" ) then 
    logger.debug("Previous connection, deleting...")
    storage.delete( "conn" )
end

-- Add device
logger.debug("Add default device during startup (if required)")
loadfile("HUB:"..PLUGIN.."/scripts/add_device")()

-- set IP Address and PORT
-- (need to move the GUI once supported)
storage.set_string("IP", "10.50.40.8")
storage.set_string("PORT", "2001")

-- Create the network connection...
loadfile("HUB:"..PLUGIN.."/scripts/create_connection")()
