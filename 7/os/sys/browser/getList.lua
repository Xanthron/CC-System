local l1, l2 = {}, dofile("os/sys/browser/data/unofficial")
if www.pasteBinSave(dofile("os/sys/browser/data/settings.set").official, "os/sys/browser/data/official", true) then
    l1 = dofile("os/sys/browser/data/official")
end
return l1, l2
