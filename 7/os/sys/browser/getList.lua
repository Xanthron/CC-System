local l1 = {}
if www.pasteBinSave(dofile("os/sys/browser/data/settings.set").official, "os/sys/browser/data/official", true) then
    l1 = dofile("os/sys/browser/data/official")
end
return l1, dofile("os/sys/browser/data/unofficial"), dofile("os/sys/browser/data/installed")
