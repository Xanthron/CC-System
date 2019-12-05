--- Create a new `parallelManager`
---@return parallelManager
function new()
    --- A class for handling events that should occur parallel, where parallel means execute a function to the next yield and switching to the next function executing it til the next yield looping until the *stop* function is called or any function is finished, or functions ar added or removed.
    ---@class parallelManager
    local this = {}

    ---@type parallelElement[]
    this._parallelElements = {}

    --- Add a function and data to create automatically a `parallelElement` and add it in the parallel que. To accomplish an init after adding the que is stopped by the next yield and every function starts from the beginning. E.g. therefor the data is used to store the progress.
    ---@param func function
    ---@param data table
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
    --- Removes the `parallelManager` with te corresponding function from the que. To accomplish an init without the removed function the que is stopped by the next yield and every function starts from the beginning. E.g. therefor the data is used to store the progress.
    ---@param func function
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
    --- Intern function that is automatically added at the and of the que. It stops the parallel execution, when *stop()* is called, or a function is added or removed
    this._waitForChange = function()
        while this._stop == false do
            coroutine.yield()
        end
    end

    --- Start the parallel que by executeing a function in the que to the next yield and switching to the next function executing it til the next yield looping until the *stop* function is called or any function is finished, or functions ar added or removed. The first item in the que is executed as first the last function is the *_waitForChange()* function and cant be removed
    this.init = function()
        this._stop = false
        local functions = {}
        for i = 1, #this._parallelElements do
            table.insert(functions, this._parallelElements[i].init)
        end
        table.insert(functions, this._waitForChange)
        parallel.waitForAny(table.unpack(functions))
    end

    --- Stops the execution of the que.
    this.stop = function()
        this._stop = true
    end
    --- Returns true if the que is in a parallel process.
    ---@return boolean
    this.isRunning = function()
        return this._stop == false
    end

    return this
end
