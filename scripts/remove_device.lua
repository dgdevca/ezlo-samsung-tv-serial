local storage = require("storage")
local core = require("core")
local PLUGIN = storage.get_string("PLUGIN")
local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/remove_device").setLevel(storage.get_number("log_level") or 99)

local function remove_device()
	-- Find the devices for this gateway. Each gateway (= plugin of type gateway) has its own 
	local gateway = core.get_gateway()
	local self_id = gateway.id
	local gw_devices = core.get_devices() or {}
	logger.debug("Hub has %1 devices", #gw_devices)
	local gateway_devices = {}
	local found_devices = 0
	for _,d in ipairs(gw_devices) do
		--logger.debug("Gateway: %1, Device ID: %2, Device Name: %3", d.gateway_id, d.id, d.name)
		if d.gateway_id == self_id then
            logger.debug("Found existing device: %1, id: %2", d.name, d.id)
            logger.info("Removing device id: %1", d.id)
            core.remove_device(d.id)
		end
	end
end

remove_device()
