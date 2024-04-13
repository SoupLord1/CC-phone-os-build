return function(desktop)
    local basalt = require("basalt")
    local app = desktop:addFrame()
    app:setSize("parent.w", "parent.h"):setBackground(colors.black)

    local settings_bar = app:addList():setSize("parent.w/4", "parent.h"):setBackground(colors.lightGray)
    
    settings_bar:addItem("General"):setBackground(colors.lightGray)
    settings_bar:addItem("User"):setBackground(colors.lightGray)
    settings_bar:addItem("Appearance"):setBackground(colors.lightGray)

    

    settings_bar:onSelect(function(self, event, item)
        basalt.debug(item.text)
    end)
    
    return app
end

