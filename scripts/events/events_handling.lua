local params = ...

local storage = require("storage")
local core = require("core")
local PLUGIN = storage.get_string("PLUGIN")
local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/events_handling").setLevel(storage.get_number("log_level") or 99)

logger.debug("params.event: %1", params.event)

local handler = loadfile( "HUB:"..PLUGIN.."/scripts/events/" .. params.event )

if handler then
    logger.debug("Handler with params: %1", params)
    handler( params )
else
    --logger.error("Unsupported event: ".. params.event)   -- This call fails, have to use print instead...
    print( PLUGIN.." events handling: Unsupported event " .. params.event )
end
