---Create a new inputField
---@param parent element
---@param label string|nil
---@param text string
--TODO remove multiline, it is not in use
---@param multiLine boolean
--TODO remove onSubmit
---@param onSubmit function
---@param style style.inputField
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return inputField
function new(parent, label, text, multiLine, onSubmit, style, x, y, w, h)
    ---Input field
    ---@class inputField:element
    local this = ui.element.new(parent, "inputField", x, y, w, h)

    ---@type style.inputField
    this.style = style
    ---@type string
    this.text = nil
    ---@type string|nil
    this.label = label
    ---@type boolean
    this.multiLine = multiLine
    ---@type function
    this._onSubmit = onSubmit
    ---@type repeatItem
    this.repeatItem = ui.repeatItem.new(0.8, 0, 0)
    ---@type integer
    this._cursorX = 1
    ---@type integer
    this._cursorY = 1
    ---@type string[]
    this.autoComplete = {}
    ---@type integer
    this.autoCompleteIndex = 1
    ---@type function
    this.onSuggestCompletion = nil
    ---@type function
    this.onAutoCompletion = nil
    ---@type function
    this.onTextEdit = nil
    ---@type string[]
    this.ignoreKeys = {
        "tab",
        "leftCtrl",
        "grave",
        "leftShift",
        "rightShift",
        "leftAlt",
        "capsLock",
        "f1",
        "f2",
        "f3",
        "f4",
        "f5",
        "f6",
        "f7",
        "f8",
        "f9",
        "f10",
        "numLock",
        "scollLock",
        "f11",
        "f12",
        "f13",
        "f14",
        "f15",
        "kana",
        "convert",
        "noconvert",
        "yen",
        "colon",
        "kanji",
        "stop",
        "ax",
        "rightCtrl",
        "rightAlt",
        "pause",
        "up",
        "pageUp",
        "down",
        "pageDown",
        "insert",
        "delete"
    }
    ---@type integer
    this.cursorOffset = 0

    this.getCursorPos = function()
        if this.mode == 3 then
            return true, this:getGlobalPosX() + this._cursorX, this:getGlobalPosY() + this._cursorY, colors.red
        end
    end

    ---Set the text of this field and set the cursor to the index or at the end
    ---@param text string
    ---@param index integer|optional
    ---@return nil
    function this:setText(text, index)
        self.text = text
        if self.onTextEdit then
            local text = self:onTextEdit("text", text)
            if text then
                self.text = text
            end
        end
        if index == -1 then
            index = self.cursorOffset
        end
        if index then
            self.cursorOffset = math.max(0, math.min(text:len(), index))
        else
            self.cursorOffset = text:len()
        end
        if self.mode > 2 then
            self:getAutoComplete()
        end
    end
    ---Intern function to insert in the autocompletion table
    ---@return nil
    function this:getAutoComplete()
        if self.onSuggestCompletion then
            self:onSuggestCompletion(self.text, self.cursorOffset)
        end
        self.autoCompleteIndex = 1
    end
    ---Only recalculate the text
    ---@return nil
    function this:recalculateText()
        local theme
        if self.mode == 1 or self.mode == 4 then
            theme = self.style.nTheme
        elseif self.mode == 2 then
            theme = self.style.dTheme
        else
            theme = self.style.sTheme
        end
        local left = #theme.b[4]
        local top = #theme.b[2]
        local right = #theme.b[6]
        local bottom = #theme.b[8]
        local width = self:getWidth()
        local length = self.text:len()
        if self.mode <= 2 then
            local text
            if length > width then
                local align = self.style.align
                if align == 1 or align == 4 or align == 7 then
                    text = self.text:sub(1, width - left - right - 3) .. "..."
                elseif align == 2 or align == 1 or align == 8 then
                    local w = width - left - right - 3
                    text = self.text:sub(1, math.floor(w / 2)) .. "..." .. self.text:sub(length - math.ceil(w / 2))
                else
                    text = "..." .. self.text:sub(length - width + left + right + 3)
                end
            else
                text = self.text
            end
            ui.buffer.labelBox(self.buffer, text, theme.tC, theme.tBG, 1, theme.b[5][1], left, top, right, bottom)
        else
            self:getManager().getCursorPos = self.getCursorPos
            local completeText
            if #self.autoComplete > 0 then
                completeText = self.autoComplete[self.autoCompleteIndex]
            else
                completeText = ""
            end
            local completeLength = completeText:len()
            local offsetT = length - (width - left - right) + 1
            offsetT = math.min(offsetT, self.cursorOffset - width + left + right + 1)
            local offsetC = math.max(0, math.min(width - left - right - 3, completeLength, length + completeLength - width - left - right + 3))
            offsetT = offsetT + offsetC
            offsetT = math.max(0, offsetT)
            self._cursorX = self.buffer.rect.x + left + self.cursorOffset - offsetT - self:getGlobalPosX()
            self._cursorY = self.buffer.rect.y + top - self:getGlobalPosY()
            if completeText == "" then
                local text = self.text:sub(offsetT + 1, math.min(offsetT + width - left - right, length))
                ui.buffer.labelBox(self.buffer, text, theme.tC, theme.tBG, 1, theme.b[5][1], left, top, right, bottom)
            else
                local text = self.text:sub(offsetT + 1, math.min(offsetT + width - left - right - offsetC, length))
                ui.buffer.labelBox(self.buffer, text, theme.tC, theme.tBG, 1, theme.b[5][1], left, top, right, bottom)
                ui.buffer.labelBox(self.buffer, completeText, theme.complC, theme.complBG, 1, theme.b[5][1], left + self.cursorOffset - offsetT, top, right, bottom)
                text = self.text:sub(offsetT + width - left - right - offsetC, math.min(offsetT + width - left - right, length))
                ui.buffer.labelBox(self.buffer, text, theme.tC, theme.tBG, 1, theme.b[5][1], left + length + completeLength - offsetT, top, right, bottom)
            end
        end
    end
    ---Recalculate the buffer of this element
    ---@return nil
    function this:recalculate()
        local theme
        local labelTheme
        if self.mode == 1 or self.mode == 4 then
            theme = self.style.nTheme
            labelTheme = self.style.label.nTheme
        elseif self.mode == 2 then
            theme = self.style.dTheme
            labelTheme = self.style.label.dTheme
        else
            theme = self.style.sTheme
            labelTheme = self.style.label.sTheme
        end
        ui.buffer.borderBox(self.buffer, theme.b, theme.bC, theme.bBG)
        if self.label then
            local yPos = math.max(0, math.floor((#theme.b[2] - 1) / 2))
            ui.buffer.labelBox(self.buffer, self.label, labelTheme.tC, labelTheme.tBG, self.style.label.align, nil, #theme.b[4], yPos, #theme.b[6], self.buffer.rect.h - yPos)
        end
        self:recalculateText()
    end
    ---Assigned function for every event except events dedicated to the mouse
    ---@param event event
    ---@return element|nil
    function this:_doNormalEvent(event)
        if self.mode == 3 then
            if event.name == "char" then
                local char
                if self.onTextEdit then
                    char = self:onTextEdit("char", event.param1, self.text:sub(1, self.cursorOffset) .. event.param1 .. self.text:sub(self.cursorOffset + 1))
                end
                if not char then
                    char = event.param1
                end
                self.text = self.text:sub(1, self.cursorOffset) .. char .. self.text:sub(self.cursorOffset + 1)
                self.cursorOffset = self.cursorOffset + char:len()
                self:getAutoComplete()
                self:recalculateText()
                self:repaint("this")
                return self
            elseif event.name == "paste" then
                local paste
                if self.onTextEdit then
                    paste = self:onTextEdit("paste", event.param1)
                end
                if not paste then
                    paste = event.param1
                end
                self.text = self.text:sub(1, self.cursorOffset) .. paste .. self.text:sub(self.cursorOffset + 1)
                self.cursorOffset = self.cursorOffset + paste:len()
                self:getAutoComplete()
                self:recalculateText()
                self:repaint("this")
                return self
            elseif event.name == "key" then
                local key = keys.getName(event.param1)
                if key == "backspace" then
                    if self.cursorOffset > 0 and self.repeatItem:call() and (not self.onTextEdit or not (self:onTextEdit("delete", self.cursorOffset) == false)) then
                        self.text = self.text:sub(1, self.cursorOffset - 1) .. self.text:sub(self.cursorOffset + 1)
                        self.cursorOffset = self.cursorOffset - 1
                        self:getAutoComplete()
                        self:recalculateText()
                        self:repaint("this")
                    end
                elseif key == "delete" then
                    if self.cursorOffset < self.text:len() and self.repeatItem:call() then
                        if not self.onTextEdit or not (self:onTextEdit("delete", self.cursorOffset) == false) then
                            self.text = self.text:sub(1, self.cursorOffset) .. self.text:sub(self.cursorOffset + 2)
                            self:getAutoComplete()
                            self:recalculateText()
                            self:repaint("this")
                        end
                    end
                elseif key == "home" then
                    if self.repeatItem:call() and self.cursorOffset > 0 then
                        self.cursorOffset = 0
                        self:getAutoComplete()
                        self:recalculateText()
                        self:repaint("this")
                    end
                elseif key == "end" then
                    if self.repeatItem:call() and self.cursorOffset < self.text:len() then
                        self.cursorOffset = self.text:len()
                        self:getAutoComplete()
                        self:recalculateText()
                        self:repaint("this")
                    end
                elseif key == "left" then
                    if self.repeatItem:call() and self.cursorOffset > 0 then
                        self.cursorOffset = self.cursorOffset - 1
                        self:getAutoComplete()
                        self:recalculateText()
                        self:repaint("this")
                    end
                elseif key == "right" then
                    if self.repeatItem:call() then
                        local success = false
                        if #self.autoComplete > 0 then
                            local text
                            success, text, self.cursorOffset = self:onAutoCompletion(self.text, self.cursorOffset, self.autoComplete[self.autoCompleteIndex])
                            if self.onTextEdit then
                                text = self:onTextEdit("autocomplete", text)
                            end
                            self.text = text
                        end
                        if not success then
                            self.cursorOffset = math.min(self.text:len(), self.cursorOffset + 1)
                        end
                        self:getAutoComplete()
                        self:recalculateText()
                        self:repaint("this")
                    end
                elseif key == "up" then
                    if #self.autoComplete > 0 then
                        if self.autoCompleteIndex <= 1 then
                            self.autoCompleteIndex = #self.autoComplete
                        else
                            self.autoCompleteIndex = self.autoCompleteIndex - 1
                        end
                        self:recalculateText()
                        self:repaint("this")
                        return self
                    end
                elseif key == "down" then
                    if #self.autoComplete > 0 then
                        if self.autoCompleteIndex >= #self.autoComplete then
                            self.autoCompleteIndex = 1
                        else
                            self.autoCompleteIndex = self.autoCompleteIndex + 1
                        end
                        self:recalculateText()
                        self:repaint("this")
                        return self
                    end
                end
                for index, value in ipairs(self.ignoreKeys) do
                    if key == value then
                        return
                    end
                end
                return self
            elseif event.name == "key_up" then
                local key = keys.getName(event.param1)
                if key == "enter" then
                    if self._onSubmit then
                        self:_onSubmit(event, self.text)
                    end
                    return self
                end
                for index, value in ipairs(self.ignoreKeys) do
                    if key == value then
                        return
                    end
                end
                self.repeatItem:reset()
                return self
            end
        end
    end
    ---Assigned function for every event dedicated to the mouse
    ---@param event event
    ---@param x integer|optional
    ---@param y integer|optional
    ---@param w integer|optional
    ---@param h integer|optional
    ---@return element|nil
    function this:_doPointerEvent(event, x, y, w, h)
        x, y, w, h = ui.rect.overlaps(x, y, w, h, self.buffer.rect:getUnpacked())
        if event.name == "mouse_click" then
            if event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                self.mode = 3
                self:recalculate()
                self:repaint("this", x, y, w, h)
                return self
            end
        elseif event.name == "mouse_drag" then
            if self.mode == 4 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                self.mode = 3
                self:recalculate()
                self:repaint("this", x, y, w, h)
            elseif self.mode == 3 and (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h) then
                self.mode = 4
                self:recalculate()
                self:repaint("this", x, y, w, h)
            end
        elseif event.name == "mouse_up" then
            if self.mode == 3 and event.param2 >= x and event.param2 < x + w and event.param3 >= y and event.param3 < y + h then
                return self
            elseif self.mode == 4 and (event.param2 < x or event.param2 >= x + w or event.param3 < y or event.param3 >= y + h) then
                self.mode = 1
                self:recalculate()
                self:repaint("this", x, y, w, h)
                return self
            end
        end
    end

    this:setText(text)
    this:recalculate()

    return this
end
