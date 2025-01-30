return function(desktop)

    local JSON = require("modules.json.json")

    local device_info_file = fs.open("os/default_apps/storage/settings/data/device_info.json","r")
    
    local device_info = JSON:decode(device_info_file.readAll())

    device_info_file.close()

    local adjustments = {
        content = {x=0}
    }

    if device_info.device_type == "mobile" then
        adjustments.content.x = 1
    end
    
    local app = desktop:addFrame()
    app:setSize("parent.w", "parent.h"):setBackground(colors.black)

    local settings_bar = app:addList():setSize("parent.w/4", "parent.h"):setBackground(colors.lightGray)

    local general = app:addFrame():setBackground(colors.black):setPosition("parent.w/4 + "..adjustments.content.x, 1):setSize("parent.w/4 * 3 + 1", "parent.h"):setForeground(colors.white)

    local user = app:addFrame():setBackground(colors.black):setPosition("parent.w/4 + "..adjustments.content.x, 1):setSize("parent.w/4 * 3 + 1", "parent.h"):hide()
    local userPage = require("default_apps/storage/settings/pages/user/user")(user)

    local theme = app:addFrame():setBackground(colors.gray):setPosition("parent.w/4 + "..adjustments.content.x, 1):setSize("parent.w/4 * 3 + 1", "parent.h"):hide()

    local dev = app:addFrame():setBackground(colors.black):setPosition("parent.w/4 + "..adjustments.content.x, 1):setSize("parent.w/4 * 3 + 1", "parent.h"):hide()
    local dev_shell = dev:addProgram()
    dev_shell:execute("shell")
    
    settings_bar:addItem("General"):setBackground(colors.lightGray)
    settings_bar:addItem("User"):setBackground(colors.lightGray)
    settings_bar:addItem("Theme"):setBackground(colors.lightGray)
    settings_bar:addItem("Shell"):setBackground(colors.lightGray)



    settings_bar:onSelect(function(self, event, item)
        general:hide()
        user:hide()
        theme:hide()
        dev:hide()
        if item.text == "General" then
            general:show()
        end
        if item.text == "User" then
            user:show()
        end
        if item.text == "Theme" then
            theme:show()
        end
        if item.text == "Shell" then
            dev:show()
        end
        
    end)
    
    return app
end

