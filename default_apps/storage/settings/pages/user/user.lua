return function(user)

    local JSON = require("modules.json.json")

    local device_info_file = fs.open("os/default_apps/storage/settings/data/device_info.json","r")
    
    local device_info = JSON:decode(device_info_file.readAll())

    device_info_file.close()

    local adjustments = {
        button = {w=0,x=0}
    }

    if device_info.device_type == "mobile" then
        adjustments.button.w = -2
        adjustments.button.x = 0
    end
    
    local user_settings = user:addFrame():setSize("parent.w", "parent.h"):setBackground(colors.black):hide()
    local user_settingsPage = require("default_apps/storage/settings/pages/user/user_settings")(user_settings)
    local user_settings_button = user:addButton():setText("User Settings"):setSize("parent.w-2+"..adjustments.button.w, 3):setPosition("2+"..adjustments.button.x, 2):onClick(function() user_settings:show() end)

    local password_settings = user:addFrame():setSize("parent.w", "parent.h"):setBackground(colors.black):hide()
    local password_settingsPage = require("default_apps/storage/settings/pages/user/password_settings")(password_settings)
    local password_settings_button = user:addButton():setText("Password Config"):setSize("parent.w-2+"..adjustments.button.w, 3):setPosition("2+"..adjustments.button.x, 6):onClick(function() password_settings:show() end)

    
    
end