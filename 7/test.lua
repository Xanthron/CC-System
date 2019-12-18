print(("testing"):gsub("%g", "."))
while true do
    local event, par1 = os.pullEvent("key_up")
    print(par1)
    local key = keys.getName(par1)
    print(key)
    print(key:match("g"))
    print(string.char(par1))
end
