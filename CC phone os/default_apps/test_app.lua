return function(desktop)
    local app = desktop:addFrame()
    app:setSize("parent.w", "parent.h"):setBackground(colors.green)

    return app
end

