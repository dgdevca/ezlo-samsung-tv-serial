# ezlo samsung-tv-serial


A very simple plugin to control a Samsung TV using serial (RS232) commands over the network via a using a Digi PortServer.
```
-----------     TCP     -------------------     Serial/RS232     --------------
|  Ezlo   |  ---------> | Digi PortServer | -------------------> | Samsung TV |
-----------             -------------------                      --------------
                        IP / Port
```

Use the following custom call to turn the Power ON (or OFF) via the API tool:
```json
{
    "method": "extensions.plugin.run",
    "id": "_ID_",
    "params": {
        "script": "HUB:samsung-tv-serial/scripts/command",
        "scriptParams": {
            "power":"ON"
        }
    }
}
```

## Installation

1. SSH to your Ezlo
2. Make a directory for the plugin
`mkdir /opt/firmware/plugins/samsung-tv-serial`
3. Copy plugin files to this new directory
`scp -r ​<PATH_TO_PLUGIN_FOLDER>​ root@<CONTROLLER_IP>​:/opt/firmware/plugins/samsung-tv-serial`
4. Restart Ezlo to load plugin
```service firmware restart```

You can monitor the plugin log file with the following command
`tail -f /tmp/log/firmware/ha-luad.log | grep "samsung-tv-serial"`
