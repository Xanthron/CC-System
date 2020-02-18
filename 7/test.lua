local path = "test.lua"
print(path:match("[^/]%.[^/]-$"):sub(3))
