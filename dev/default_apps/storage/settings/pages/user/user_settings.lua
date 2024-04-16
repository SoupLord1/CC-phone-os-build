return function(user_settings)

    user_settings:addLabel():setText("User Settings"):setPosition("parent.w/2-self.w/2", 2):setForeground(colors.white)

    user_settings:addLabel():setText("Username"):setPosition("parent.w/2-self.w/2", 4):setForeground(colors.white)
    user_settings:addLabel():setText("Current: "):setPosition(2, 6):setForeground(colors.white)
    user_settings:addLabel():setText("New Username: "):setPosition(2, 7):setForeground(colors.white)

    local new_username = user_settings:addInput():setInputType("text"):setInputLimit(12):setPosition(16, 7):setForeground(colors.white)

    local change_username_button = user_settings:addButton():setPosition(2, 9):setSize(17, 1):setText("Change Username")

    

    

    local file = fs.open("os/default_apps/storage/settings/data/username.txt", "r")
    local current_username = file.readAll()
    file.close()

    local function change_username()
        local file = fs.open("os/default_apps/storage/settings/data/username.txt", "w")
        file.write(new_username:getValue())
        file.close()
    end

    change_username_button:onClick(change_username)

    local current_username_label = user_settings:addLabel():setText(current_username):setPosition(11, 6):setForeground(colors.white)


    local username = user_settings:addInput():setInputType("password"):setInputLimit(12):setPosition(15, 10):setForeground(colors.white)
    
    local back_button = user_settings:addButton():setText("Back"):setSize(6, 1):setPosition(2, "parent.h - 1"):onClick(function() user_settings:hide() end)

end