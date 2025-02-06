local app_fetcher = {}

local json = require("system.modules.json.json")



function app_fetcher.fetch(config)
    local sides = peripheral.getNames()

    for _ , side in pairs(sides) do
        if peripheral.getType(side) == "modem" then
            rednet.open(side)
        end
    end

    repeat
        rednet.send(config.server, json:encode({task = "fetch_app", app = config.app}))
        id, data = rednet.receive()
    until id == config.server

    return load(data)
end



return app_fetcher