local test = {x = 0, l = {}}
function test:add1()
    self.x = self.x + 1
end

function test.l.test(text)
    print(text)
end

test:add1()

print(test.x)
test.l.test("lol")
