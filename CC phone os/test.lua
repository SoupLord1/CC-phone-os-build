while true do
    local type, key, held = os.pullEvent("key")
    print(type)
    print(key)
    print(held)
end