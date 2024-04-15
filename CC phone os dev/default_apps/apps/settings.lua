return function(desktop)
    local sha2 = require("modules.sha2.sha2")
    local basalt = require("basalt")
    local app = desktop:addFrame()
    app:setSize("parent.w", "parent.h"):setBackground(colors.black)

    local general = app:addFrame():setBackground(colors.black):setPosition("parent.w/4", 1):setSize("parent.w/4 * 3 + 1", "parent.h"):setForeground(colors.white)
    

    local user = app:addFrame():setBackground(colors.black):setPosition("parent.w/4", 1):setSize("parent.w/4 * 3 + 1", "parent.h"):hide()

    user:addLabel():setText("Password Settings"):setPosition(2, 2):setForeground(colors.white)
    user:addLabel():setText("New Password: "):setPosition(2, 4):setForeground(colors.white)
    local new_password = user:addInput():setInputType("password"):setInputLimit(12):setPosition(15, 4):setForeground(colors.white)
    user:addLabel():setText("Old Password: "):setPosition(2, 5):setForeground(colors.white)
    local old_password = user:addInput():setInputType("password"):setInputLimit(12):setPosition(15, 5):setForeground(colors.white)

    local change_password_response = user:addLabel():setPosition(2, 8)
    local function change_password()
        local file = fs.open("os/default_apps/storage/settings/password.txt", "r")
        local password = file.readAll()
        file.close()

        if sha2.sha224(old_password:getValue()) == password then
            local file = fs.open("os/default_apps/storage/settings/password.txt", "w")
            file.write(sha2.sha224(new_password:getValue()))
            file.close()
            change_password_response:setText("Password Changed!"):setForeground(colors.green)
            
        else
            change_password_response:setText("Incorrect Old Password!"):setForeground(colors.red)
        end
        new_password:setValue("")
        old_password:setValue("")
    end

    local change_password_button = user:addButton():setPosition(2, 7):setSize(17, 1):setText("Change Password"):onClick(change_password)


    local appearance = app:addFrame():setBackground(colors.gray):setPosition("parent.w/4", 1):setSize("parent.w/4 * 3 + 1", "parent.h"):hide()

    local settings_bar = app:addList():setSize("parent.w/4", "parent.h"):setBackground(colors.lightGray)
    
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

