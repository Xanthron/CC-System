ui.input = {}

ui.input.term = term

function ui.input.new()
    local this = {}

    this.parallelManager = ui.parallelManager.new()
    this.uiEvents = {
        "char",
        "key",
        "key_up",
        "paste",
        "mouse_click",
        "mouse_up",
        "mouse_scroll",
        "mouse_drag",
        "mouse_drag",
        "monitor_touch"
    }
    this.event = ui.event.new()
    this._exit = false
    ---@type function
    this._callFunction = nil

    function this._eventLoop(tab)
        while true do
            this.event:pull()
            local name = this.event.name
            local current
            if table.contains(this.uiEvents, name) then
                if name == "monitor_touch" then
                    ui.input.term = tab[peripheral.wrap(this.event.param1)]
                end
                current = ui.input.term
                local drawer = tab[current]
                if drawer then
                    drawer(this.event)
                end
            else
                for i, v in ipairs(tab) do
                    if v(this.event) then
                        break
                    end
                end
            end
        end
        this._exit = false
    end

    function this:eventLoop(tab)
        this.parallelManager:addFunction(this._eventLoop, tab)
        while self._exit == false do
            self.parallelManager:init()
            if this._callFunction then
                this._callFunction()
                this._callFunction = nil
            end
        end
        this.parallelManager:clear()
        self._exit = false
    end

    function this:exit()
        self.parallelManager:stop()
        self._exit = true
    end

    --Function to break out of the event loop and execute functions without distraction
    function this:callFunction(func)
        self.parallelManager:stop()
        self._callFunction = func
    end

    function this:focus()
        --TODO enable one element to focus, so no element can steel te execution, maybe unnecessary
    end

    return this
end
