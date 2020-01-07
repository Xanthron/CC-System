function new()
    local this = {name = nil, param1 = nil, param2 = nil, param3 = nil, param4 = nil, param5 = nil}
    this.getUnpacked = function()
        return this.name, this.param1, this.param2, this.param3, this.param4, this.param5
    end
    this.pull = function(name)
        this.name, this.param1, this.param2, this.param3, this.param4, this.param5 = os.pullEvent(name)
    end
    this.pullRaw = function(name)
        this.name, this.param1, this.param2, this.param3, this.param4, this.param5 = os.pullEvent(name)
    end
    return this
end
