function new()
    local this = {}
    this._parallelElements = {}
    this.addFunction = function(func, data)
        if type(func) == "table" then
            for i = 1, #this._parallelElements do
                if this._parallelElements == func then
                    return
                end
            end
            func.caller = this
            if data then
                func.data = data
            end
            table.insert(this._parallelElements, func)
        else
            for i = 1, #this._parallelElements do
                if this._parallelElements.func == func then
                    return
                end
            end
            table.insert(this._parallelElements, ui.parallelElement.new(this, func, data))
        end
        this._stop = true
    end
    this.removeFunction = function(func)
        if type(func) == "table" then
            for i = 1, #this._parallelElements do
                if this._parallelElements[i] == func then
                    table.remove(this._parallelElements, i)
                    this._stop = true
                    return true
                end
            end
        else
            for i = 1, #this._parallelElements do
                if this._parallelElements[i]._func == func then
                    table.remove(this._parallelElements, i)
                    this._stop = true
                    return true
                end
            end
        end
        return false
    end
    this._stop = true
    this._waitForChange = function()
        while this._stop == false do
            coroutine.yield()
        end
    end
    this.init = function()
        this._stop = false
        local functions = {}
        for i = 1, #this._parallelElements do
            table.insert(functions, this._parallelElements[i].init)
        end
        table.insert(functions, this._waitForChange)
        parallel.waitForAny(table.unpack(functions))
    end
    this.stop = function()
        this._stop = true
    end
    this.isRunning = function()
        return this._stop == false
    end
    return this
end
