ui.event = {}
---Create a new event container
---@return event
function ui.event.new()
    ---Contains the event name and parameter. The max amount of parameter is 5
    ---@class event
    local this = {param1 = nil, param2 = nil, param3 = nil, param4 = nil, param5 = nil}

    ---@type string
    this.name = nil

    ---Unpack this this table
    ---@return string,any,any,any,any,any
    function this:getUnpacked()
        return self.name, self.param1, self.param2, self.param3, self.param4, self.param5
    end
    ---Execute the os.pullEvent() and saves the result in this table
    ---@param name string|"nil"
    ---@return nil
    function this:pull(name)
        self.name, self.param1, self.param2, self.param3, self.param4, self.param5 = os.pullEvent(name)
    end
    ---Execute the os.pullRawEvent() and saves the result in this table
    ---@param name string|"nil"
    ---@return nil
    function this:pullRaw(name)
        self.name, self.param1, self.param2, self.param3, self.param4, self.param5 = os.pullRawEvent(name)
    end
    return this
end
