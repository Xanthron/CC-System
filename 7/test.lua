local name = "[123.536.156]  Was auch immmer"

local s, e = name:find("^%[[0-9]-%.[0-9]-%.[0-9]-%]%s*") --TODO Überprüfen ob das klappt
if s then
    local version = {}
    local versionText = name:sub(s + 1, e - 1)
    name = name:sub(e + 1)
    for n in versionText:gmatch("[0-9]+") do
        table.insert(version, tonumber(n))
        print(n)
    end
-- if not compareVersion(version, installed[i].version) then
--     break
-- end
end
s, e = name:find("^%[force%]%s*")
if s then
    name = name:sub(e + 1)
--break
end

--return

print(name)
