return function(desktop)
    
    local basalt = require("modules.basalt.basalt")
    local app = desktop:addFrame()
    app:setSize("parent.w", "parent.h"):setBackground(colors.black)

    local settings_bar = app:addList():setSize("parent.w/4", "parent.h"):setBackground(colors.lightGray)

    local general = app:addFrame():setBackground(colors.black):setPosition("parent.w/4", 1):setSize("parent.w/4 * 3 + 1", "parent.h"):setForeground(colors.white)

    local user = app:addFrame():setBackground(colors.black):setPosition("parent.w/4", 1):setSize("parent.w/4 * 3 + 1", "parent.h"):hide()
    local userPage = require("default_apps/storage/settings/pages/user/user")(user)

    local appearance = app:addFrame():setBackground(colors.gray):setPosition("parent.w/4", 1):setSize("parent.w/4 * 3 + 1", "parent.h"):hide()

    
    settings_bar:addItem("General"):setBackground(colors.lightGray)
    settings_bar:addItem("User"):setBackground(colors.lightGray)
    settings_bar:addItem("Appearance"):setBackground(colors.lightGray)



    settings_bar:onSelect(function(self, event, item)
        if item.text == "General" then
            general:show()
            user:hide()
            appearance:hide()
        end
        if item.text == "User" then
            general:hide()
            user:show()
            appearance:hide()
        end
        if item.text == "Appearance" then
            general:hide()
            user:hide()
            appearance:show()
        end
        
    end)
    
    return app
end

