local sides = peripheral.getNames()

for _ , side in pairs(sides) do
    print(side)
    if peripheral.getType(side) == "modem" then
        print("Modem located: "..side)
    end
end