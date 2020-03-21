local com = peripheral.wrap("bottom")
for key, value in pairs(com) do
    print(key, value)
    sleep(0.5)
end
