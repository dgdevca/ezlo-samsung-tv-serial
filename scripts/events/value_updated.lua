-- when hub events update the value of items (ie. GUI power toggle, etc)
-- params sent by hub are: item_id, value
local params = ...

local storage = require("storage")
local core = require("core")
local PLUGIN = storage.get_string("PLUGIN")
local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/value_updated").setLevel(storage.get_number("log_level") or 99)

logger.debug("Params: %1", params)

local command = storage.get_string(params.item_id)

logger.debug("Command (item type) is: %1", command)

-- call the command script with the right parameters...
if command == "POWER" then
    if params.value then  -- true == ON
        logger.debug("POWER = ON")
        loadfile("HUB:"..PLUGIN.."/scripts/command")({power="ON"})
    else -- false
        logger.debug("POWER = OFF")
        loadfile("HUB:"..PLUGIN.."/scripts/command")({power="OFF"})
    end
end

if command == "VOLUME" then
    if params.value == "UP" then
        logger.debug("VOLUME = UP")
        loadfile("HUB:"..PLUGIN.."/scripts/command")({volumne="UP"})
    elseif params.value == "DOWN" then
        logger.debug("VOLUME = DOWN")
        loadfile("HUB:"..PLUGIN.."/scripts/command")({volume="DOWN"})
    elseif params.value == "MUTE" then
        logger.debug("VOLUME = MUTE")
        loadfile("HUB:"..PLUGIN.."/scripts/command")({volumne="MUTE"})
    end
end