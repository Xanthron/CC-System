local p1, p2, p3 = "os/sys/browser/data/official", "os/sys/browser/data/unofficial", "os/sys/browser/data/installed"
local l1 = {}
if ... ~= false and www.pasteBinSave(dofile("os/sys/browser/data/settings.set").official, p1, true) then
    l1 = dofile(p1)
    if not fs.exists(p3) then
        local h = fs.open(p3, "w")
        h.write("return{}")
        h.close()
        callfile("os/sys/browser/install.lua", 1, l1[1])
    end
end
if not fs.exists(p2) then
    local h = fs.open(p2, "w")
    h.write("return{}")
    h.close()
end
return l1, dofile(p2), dofile("os/sys/browser/data/installed")
