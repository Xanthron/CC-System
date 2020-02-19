local text = "test\n\nwas\noder\n\n\nhi"

local s, e = 0, 0

repeat
    print(s, e)
    s, e = text:find("[\n\r]", s + 1)
until s == nil
