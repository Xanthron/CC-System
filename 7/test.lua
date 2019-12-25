local testText = "testTextOderSo.lua:1234:Was auch immer"

local startIndex, endIndex = testText:find(":[1-9]+:")
print(testText:sub(0, startIndex - 1))
print(testText:sub(startIndex + 1, endIndex - 1))
print(testText:sub(endIndex + 1))
