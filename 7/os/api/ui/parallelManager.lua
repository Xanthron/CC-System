ui.parallelManager = {}
---Create a new parallelManager
---@return parallelManager
function ui.parallelManager.new()
    ---Handles the parallel execution of functions
    ---@class parallelManager
    local this = {}

    ---@type parallelElement[]
    this._parallelElements = {}
    ---@type boolean
    this._stop = true

    ---Add a new function or parallelElement with data
    ---@param func function|parallelElement
    ---@param data table
    ---@return nil
    function this:addFunction(func, data)
        if type(func) == "table" then
            for i = 1, #self._parallelElements do
                if self._parallelElements == func then
                    return
                end
            end
            func.caller = self
            if data then
                func.data = data
            end
            table.insert(self._parallelElements, func)
        else
            for i = 1, #self._parallelElements do
                if self._parallelElements.func == func then
                    return
                end
            end
            table.insert(self._parallelElements, ui.parallelElement.new(self, func, data))
        end
        self:stop()
    end
    ---Remove a function or parallelElement with data
    ---@param func function|parallelElement
    ---@return boolean
    function this:removeFunction(func)
        if type(func) == "table" then
            for i = 1, #self._parallelElements do
                if self._parallelElements[i] == func then
                    table.remove(self._parallelElements, i)
                    self:stop()
                    return true
                end
            end
        else
            for i = 1, #self._parallelElements do
                if self._parallelElements[i]._func == func then
                    table.remove(self._parallelElements, i)
                    self:stop()
                    return true
                end
            end
        end
        return false
    end
    ---Intern function fot waiting to stop
    ---@return nil
    function this._waitForChange()
        while this._stop == false do
            coroutine.yield()
        end
    end
    ---Start the parallel process
    ---@return nil
    function this:init()
        self._stop = false
        local functions = {}
        for i = 1, #self._parallelElements do
            table.insert(functions, self._parallelElements[i].init)
        end
        table.insert(functions, self._waitForChange)
        parallel.waitForAny(table.unpack(functions))
    end
    ---Stops the parallel process
    ---@return nil
    function this:stop()
        self._stop = true
    end
    ---Get the running state
    ---@return boolean
    function this:isRunning()
        return self._stop == false
    end
    return this
end
