ui.theme = {}
---Load a theme from "os/theme"
function ui.theme.load(name)
    local path = "os/theme/" .. name
    local path2 = "os/theme/_" .. name
    if fs.exists(path2) then
        dofile(path2)
    end
    return fs.doFile(path)
end
