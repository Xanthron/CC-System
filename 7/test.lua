local test = {x = 0}
function test:add1()
    self.x = self.x + 1
end

test:add1()

print(test.x)
