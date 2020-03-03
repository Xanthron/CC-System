local function func1()
    local event, p1 = os.pullEvent()
    if event == "char" then
        print(p1)
    end
end
local function func2()
    local event, p1 = os.pullEvent()
    if event == "mouse_click" then
        print("what")
    end
end

while true do
    parallel.waitForAny(func1, func2)
end
