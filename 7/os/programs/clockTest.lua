n0 = 30
local object1_base = {
    function1 = function(self)
        for i = 1, n0 do
            self.number = self[i]
        end
    end
}
local object1_meta = {
    __index = function(self, key)
        local meta = getmetatable(self)
        setmetatable(self, nil)
        local index = self[key]
        setmetatable(self, meta)
        if index then
            return index
        else
            return object1_base[key]
        end
    end
}
local function newObject1()
    local this = {}
    this.number = 0
    for i = 1, n0 do
        this[i] = math.random(1, 100)
    end
    setmetatable(this, object1_meta)
    return this
end
local function newObject2()
    local this = {}
    this.number = 0
    for i = 1, n0 do
        this[i] = math.random(1, 100)
    end
    this.function1 = function(self)
        for i = 1, n0 do
            self.number = self[i]
        end
    end
    return this
end
local function newObject3()
    local this = {}
    this.number = 0
    for i = 1, n0 do
        this[i] = math.random(1, 100)
    end
    this.function1 = function()
        for i = 1, n0 do
            this.number = this[i]
        end
    end
    return this
end
collector = {
    totalTime = {},
    averageTime = {},
    print = function(self)
        local averageAverageTime = 0
        local averageTotalTime = 0
        for i = 2, #self.averageTime do
            averageAverageTime = averageAverageTime + self.averageTime[i]
            averageTotalTime = averageTotalTime + self.totalTime[i]
        end
        averageAverageTime = averageAverageTime / #self.averageTime
        averageTotalTime = averageTotalTime / #self.averageTime
        print("average total time", averageTotalTime)
        print("average average Time", averageAverageTime)
    end,
    clear = function(self)
        self.totalTime = {}
        self.averageTime = {}
    end
}
diagnose = {
    timeBefore = 0,
    timeAfter = 0,
    time1 = {},
    time2 = {},
    test = function(self, object, functionName, times)
        self.timeBefore = os.clock()
        for i = 1, times do
            table.insert(self.time1, os.clock())
            object[functionName](object, times)
            table.insert(self.time2, os.clock())
        end
        self.timeAfter = os.clock()
    end,
    collect = function(self, t)
        local averageTime = 0
        for i = 1, #self.time1 do
            averageTime = averageTime + self.time2[i] - self.time1[i]
        end
        averageTime = averageTime / #self.time1
        table.insert(t.averageTime, averageTime)
        table.insert(t.totalTime, self.timeAfter - self.timeBefore)
    end,
    print = function(self)
        local averageTime = 0
        for i = 1, #self.time1 do
            averageTime = averageTime + self.time2[i] - self.time1[i]
        end
        averageTime = averageTime / #self.time1
        print("start time", self.timeBefore)
        print("end time", self.timeAfter)
        print("total time", self.timeAfter - self.timeBefore)
        print("average time", averageTime)
        print("")
    end
}
n1 = 100
n2 = 500
print("object1")
t1 = os.time()
for i = 1, n1 do
    diagnose:test(newObject1(), "function1", n2)
    diagnose:collect(collector)
end
print(os.time() - t1)
collector:print()
collector:clear()
print("object3")
t1 = os.time()
for i = 1, n1 do
    diagnose:test(newObject3(), "function1", n2)
    diagnose:collect(collector)
end
print(os.time() - t1)
collector:print()
diagnose:print()
collector:clear()
print("object2")
t1 = os.time()
for i = 1, n1 do
    diagnose:test(newObject2(), "function1", n2)
    diagnose:collect(collector)
end
print(os.time() - t1)
collector:print()
collector:clear()
