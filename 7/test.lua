local function run(...)
    shell.run("testing.lua", ...)
end

local function err(msg)
    print(msg)
end
xpcall(run, err, {1, 2})
