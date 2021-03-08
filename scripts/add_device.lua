local storage = require("storage")
local core = require("core")
local PLUGIN = storage.get_string("PLUGIN")
local logger = require("HUB:"..PLUGIN.."/scripts/utils/log").setPrefix(PLUGIN.."/scripts/add_device").setLevel(storage.get_number("log_level") or 99)

local function add_device()
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
			gateway_devices[d.id] = d
			found_devices = found_devices + 1
		end
	end

	logger.debug("gateway_devices: %1", gateway_devices)
	logger.debug("found_devices: %1", found_devices)

	-- If no devices exist for this getway, create them!
	if found_devices == 0 then
		-- Create new device
		logger.notice("Creating new Samsung TV device on gateway %1.", self_id)

		device_id, err = core.add_device{
			gateway_id = self_id,
			name = "Samsung TV",
			category = "av",
			subcategory = "",
			type = "device",
			device_type_id = "SamsungTV.RS232",
			battery_powered = false,
			persistent = false,
			info = {manufacturer = "Samsung", model = "RS232 Serial Control"}
		}
		assert(device_id,"Failed to create device, error "..(err or "unknown"))

		-- Add POWER ON/OFF, using Switch item type
		item_id, err = core.add_item{
			device_id = device_id,
			name = "switch",
			value_type = "bool", 
			value = false, 
			has_getter = true,
			has_setter = true,
			show = true
		}
		assert(item_id,"Failed add item, error "..(err or "unknown"))
		storage.set_string(item_id,"POWER")

		-- Add VOLUME, using sound_volume item type  (doesn't show in GUI yet, work in progress)
		item_id, err = core.add_item{
			device_id = device_id,
			name = "sound_volume",
			value_type = "int", 
			value = 0,
			value_min = 0,
			value_max = 100,
			has_getter = true,
			has_setter = true,
			show = true
		}
		assert(item_id,"Failed add item, error "..(err or "unknown"))
		storage.set_string(item_id,"VOLUME")

	end
end

add_device()


		
		