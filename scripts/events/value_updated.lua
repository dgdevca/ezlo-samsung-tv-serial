local params = ...

local storage = require("storage")
local core = require("core")
local PLUGIN = storage.get_string("PLUGIN")
local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/value_updated").setLevel(storage.get_number("log_level") or 99)

logger.debug("Params: %1", params)

local command = storage.get_string(params.item_id)

logger.debug("command is: %1", command)

-- call the command script with the right parameters...
if command == "POWER" then
    if params.value then
        logger.debug("POWER = ON")
        loadfile("HUB:"..PLUGIN.."/scripts/command")({power="ON"})
    else
        logger.debug("POWER = OFF")
        loadfile("HUB:"..PLUGIN.."/scripts/command")({power="OFF"})
    end
end