term.clear()
local x, y = term.getSize()
local n = 6
local k = 1
local l = 0
for j = 1, math.ceil(256 / math.floor(x / n)) do
    for i = 1, x - n, n do
        if k == 256 then
            os.pullEvent("key_up")
            return
        else
            term.setCursorPos(i, j - l)
            local k_string = tostring(k)
            term.write(table.concat({string.rep(" ", 3 - #k_string), k_string, ":", string.char(k)}))
        end
        k = k + 1
    end
    if j - l == y then
        os.pullEvent("key_up")
        l = l + 1
        term.scroll(1)
    end
end
