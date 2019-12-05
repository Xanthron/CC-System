local objectBase = {
    count = function(self)
        self.number = self.number
    end
}
local methatable = {
    __index = function(self, key)
        local meta = getmetatable(self)
        setmetatable(self, nil)
        local index = self[key]
        if index then
            return index
        else
            return objectBase[key]
        end
    end
}
local function newObject1()
    local this = {}
    this.number = 0
    setmetatable(this, methatable)
    return this
end

memory = {
    memBefore = 0,
    mem1 = {},
    mem2 = {},
    memAfter = 0,
    timeBefore = 0,
    time1 = 0,
    time2 = 0,
    timeAfter = 0,
    count = function(self, func, times)
        self.before = collectgarbage("count")
        self.timeBefore = os.clock()
        for i = 1, times do
            table.insert(self.last1, collectgarbage("count"))
            table.insert(self.time1, os.clock())
            func(i)
            table.insert(self.time2, os.clock())
            table.insert(self.last2, collectgarbage("count"))
        end
        self.timeAfter = os.clock()
        self.after = collectgarbage("count")
    end,
    diagnose = function(self)
        local average1 = 0
        local average2 = 0
        local timeAverage = 0

        for i = 2, #self.last1 do
            average1 = average1 + self.last1[i] - self.last1[i - 1]
            average2 = average2 + self.last2[i] - self.last2[i - 1]
            timeAverage = timeAverage + self.time2 - self.time1
        end
        average1 = average1 / #self.last1
        average2 = average2 / #self.last1

        print(self.before, self.after, self.after - self.before, average1, average2, average2 - average1)
    end
}
testTable = {}
memory:count(
    function(times)
        testTable[times] = newObject()
    end,
    10000
)
memory:diagnose()
--1655.826171875
--1655.826171875
--1968.310546875
