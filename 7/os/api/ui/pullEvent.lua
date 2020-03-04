ui.termManager = {}

function ui.term.new()
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

    function this:execute(tab)
        while self._exit == false do
            self.event.pull()
            local name = self.event.name
            local current
            if table.contains(self.uiEvents, name) then
                if name == "monitor_touch" then
                    ui.term.current = tab[peripheral.wrap(self.event.param1)]
                end
                current = ui.term.current
                local manager = tab[current]
                if manager then
                    manager(self.event)
                end
            else
                for i, v in ipairs(tab) do
                    if v(self.event) then
                        break
                    end
                end
            end
            ui.term.current = current
        end
        self._exit = false
    end

    function this:exit()
        self.parallelManager:stop()
        self._exit = true
    end
end
