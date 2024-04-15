periphemu.create("right", "modem") 
peripheral.find("modem", rednet.open)

local file = fs.open("os/server_hashes.txt", "r")
local fhashes = file.readAll()
file.close()

local hashes = loadstring(fhashes)

while true do
    local time = os.date("%r")
    local payload = {type=hashes[1],data=time}
    rednet.broadcast(payload)

    sleep(5)
end