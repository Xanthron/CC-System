--- Create a new event
---@return event
function new()
    --- An handle for pull events and saving the event data
    ---@class event
    local this = {name = nil, param1 = nil, param2 = nil, param3 = nil, param4 = nil, param5 = nil}

    --- unpack all event data
    ---@return string, any,any,any,any,any
    this.getUnpacked = function()
        return this.name, this.param1, this.param2, this.param3, this.param4, this.param5
    end

    --- Wait until the computer receives an event, or if target-event is specified, will block until an instance of target-event occurs.
    this.pull = function(name)
        this.name, this.param1, this.param2, this.param3, this.param4, this.param5 = os.pullEvent(name)
    end
    --- Like *pull()* but caches all events. Wait until the computer receives an event, or if target-event is specified, will block until an instance of target-event occurs.
    this.pullRaw = function(name)
        this.name, this.param1, this.param2, this.param3, this.param4, this.param5 = os.pullEvent(name)
    end

    return this
end
