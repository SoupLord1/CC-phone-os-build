return function(lock_screen)

    local basalt = require("modules.basalt.basalt")
    local JSON = require("modules.json.json")

    local function getFileContents(filepath)
        local file = fs.open(filepath, "r")
        local content = file:readAll()
        file:close()
        return content
    end

    local device_info_file = fs.open("os/default_apps/storage/settings/data/device_info.json","r")
    
    local device_info = JSON:decode(device_info_file.readAll())

    device_info_file.close()

    local adjustments = {
        passFrame = {w=0,h=0,x=0,y=0},
        passLabel = {x=0,y=0},
        passInput = {x=0,y=0},
        pass_submit = {x=0,y=0},
        exit_button = {x=0}

    }

    if device_info.device_type == "mobile" then
        adjustments.passFrame.w = 5
        adjustments.passFrame.x = 1
        adjustments.passLabel.x = 1
        adjustments.passInput.x = 1
        adjustments.pass_submit.x = 1
        adjustments.exit_button.x = 1
    end
    
    local topBar_ls = lock_screen:addFrame():setPosition(1,1):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
    local versionLabel_ls = topBar_ls:addLabel():setText("OS v1.0"):setPosition(2, 1)
    local Clock_ls = topBar_ls:addLabel():setText("Tempclock"):setPosition("parent.w-11", 1)

    local desktop_ls = lock_screen:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h-2"):setBackground(colors.black)

    local passFrame = desktop_ls:addFrame():setSize("parent.w/3 + "..adjustments.passFrame.w, "parent.h/3 + 2 + "..adjustments.passFrame.h):setPosition("parent.w/2-self.w/2 + "..adjustments.passFrame.x, "parent.h/2-self.h/2 + "..adjustments.passFrame.y):setBackground(colors.gray)
    local passLabel = passFrame:addLabel():setText(" Password:"):setPosition("parent.w/2-self.w/2 + "..adjustments.passLabel.x, "parent.h/2-self.h/2 + "..adjustments.passLabel.y):setForeground(colors.white)
    local passInput = passFrame:addInput():setInputType("password"):setInputLimit(12):setPosition("parent.w/2-self.w/2 + "..adjustments.passInput.x, "parent.h/2-self.h/2+1 + "..adjustments.passInput.y):setForeground(colors.white)
    local pass_submit = passFrame:addButton():setText("Submit"):setPosition("parent.w/2-self.w/2 + "..adjustments.pass_submit.x, "parent.h/2+3 + "..adjustments.pass_submit.y):setSize(8, 1):setBackground(colors.lightGray)
    local passReponse = passFrame:addLabel():setText(""):setPosition("parent.w/2-self.w/2", "parent.h/2+2"):setForeground(colors.white)

    local bottomBar_ls = lock_screen:addFrame():setPosition(1,"parent.h"):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
    local exit_button_ls = bottomBar_ls:addButton():setText("Exit"):setBackground(colors.lightGray):setSize(6,1):setPosition("parent.w/2-self.w/2 + "..adjustments.exit_button.x,1):onClick(basalt.stop)

    local function enterPass()
        local password = "a"
        local entered_password = "a"
        if password == entered_password then
            passInput:setValue("")
            lock_screen:hide()
        else
            passInput:setValue("")
            passReponse:setText("Incorrect"):setForeground(colors.red)
        end
    
      end
    
    pass_submit:onClick(enterPass)

    local function clockTick_ls()
        while true do
            Clock_ls:setText(os.date("%r"))
            sleep(0.01)
        end
    end
    local clockThread_ls = lock_screen:addThread()
    clockThread_ls:start(clockTick_ls)
    
    
end