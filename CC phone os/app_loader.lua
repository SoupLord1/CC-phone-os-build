local app_loader = {}

local function getImageFromString(filepath)
    local imageString = fs.open(filepath, "r")
    local image = loadstring("return"..imageString:readAll())()
    imageString:close()
    return image
end



function app_loader.get_apps()
    local app_files = fs.list("os/default_apps")


    local apps = {}

    local i = 1
    local j = 1
    while i < #app_files + 1 do
        if fs.isDir("os/default_apps/"..app_files[i]) == false then
            local app_name = string.gsub(app_files[i], ".lua", "")
            local app_handle = require("default_apps/"..app_name)
            local app_icon = getImageFromString("os/default_apps/icons/"..app_name..".bimg")
            apps[j] = {name = string.sub(app_name, 1, 5), handle = app_handle, icon = app_icon}
            j = j + 1
        end
        i = i + 1
    end
    return apps
end

function app_loader.test()
    local app_files = fs.list("os/default_apps")

    for i = 1, #app_files do
        print(app_files[i])
    end
end

return app_loader

-- Shows same Icon for all apps