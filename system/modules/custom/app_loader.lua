local app_loader = {}

local json = require("system.modules.json.json")

local system_apps_path = "os/system/apps/"
local apps_path = "os/storage/apps/"
local config_path = "/config.json"
local icon_path = "/icon.bimg"

function app_loader.get_system_apps()
    local system_apps = fs.list(system_apps_path)

    local apps_config_file = fs.open(system_apps_path..config_path, "r")
    local apps_config = json:decode(apps_config_file.readAll())

    local app_order_length = 0
    for _, _ in pairs(apps_config.app_order) do
        app_order_length = app_order_length + 1
    end

    local apps = {}

    for i = 1, #system_apps-2, 1 do
        table.insert(apps, 0)
    end

    for key, value in pairs(system_apps) do

        if (value ~= "config.json") then

            local app = {}
            -- get config
            local app_config_file = fs.open(system_apps_path..value..config_path, "r")
            local app_config = app_config_file.readAll()
            app_config_file.close()
            app_config = json:decode(app_config)

            app.config = app_config

            -- get icon

            app.icon_path = system_apps_path..value..icon_path

            local app_order = apps_config.app_order[app.config.app]

            if app_order == nil then
                app_order = app_order_length + 1
                apps_config.app_order[app.config.app] = app_order_length + 1
                
                app_order_length = app_order_length + 1

                local apps_config_file = fs.open(system_apps_path..config_path, "w")
                apps_config_file.write(json:encode_pretty(apps_config, nil, 
                { pretty = true, align_keys = false, array_newline = true, indent = "   " })
                )
                apps_config_file.close()
            end

            apps[app_order] = app
        end
    end

    return apps

end

return app_loader