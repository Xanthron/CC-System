local test = {}
local test_m = {
    __mode = ""
}

test.list = {name = "test1"}
local list = test.list
list.name = "test2"
print(test.list.name)
