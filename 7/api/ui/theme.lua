function load(name)
    print("start Load")
    local path = "os/theme/" .. name
    local path2 = "os/theme/_" .. name
    if fs.exists(path2) then
        print("do")
        dofile(path2)
    end
    return assets.variables.open(path)
end
