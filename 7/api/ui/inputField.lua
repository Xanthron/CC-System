---@param parent element
---@param label string
---@param text string
---@param multiLine boolean
---@param onSubmit function
---@param style style.inputField
function new(parent, label, text, multiLine, onSubmit, style, x, y, w, h)
    ---@class inputField:element
    local this = ui.element.new(parent, x, y, w, h)

    this.style = style
    this.text = nil
    this.label = label
    this.multiLine = multiLine

    this.cursorOffset = 0
    this.setText = function(text, index)
        this.text = text
        if index == -1 then
            index = this.cursorOffset
        end
        if index then
            this.cursorOffset = math.max(0, math.min(text:len(), index))
        else
            this.cursorOffset = text:len()
        end
    end
    this.setText(text)

    this.recalculate = function()
        ---@type style.inputField.theme
        local theme = nil
        ---@type style.label.theme
        local labelTheme = nil

        ---@type string
        local text

        if this.mode == 1 then
            theme = this.style.normalTheme
            labelTheme = this.style.label.normalTheme
            text = this.text
        elseif this.mode == 2 then
            theme = this.style.disabledTheme
            labelTheme = this.style.label.disabledTheme
            text = this.text
        else
            theme = this.style.selectedTheme
            labelTheme = this.style.label.selectedTheme
            text = this.text
        end

        ui.buffer.borderBox(this.buffer, theme.border, theme.borderColor, theme.borderBackgroundColor)
        if this.label then
            local yPos = math.max(0, math.floor((#theme.border[2] - 1) / 2))
            ui.buffer.labelBox(
                this.buffer,
                this.label,
                labelTheme.textColor,
                labelTheme.backgroundColor,
                this.style.label.alignment,
                nil,
                #theme.border[4],
                yPos,
                #theme.border[6],
                this.buffer.rect.h - yPos
            )
        end
        ui.buffer.labelBox(
            this.buffer,
            text,
            theme.textColor,
            theme.textBackgroundColor,
            1,
            theme.border[5][1],
            #theme.border[4],
            #theme.border[2],
            #theme.border[6],
            #theme.border[8]
        )
    end
    this.recalculate()

    ---@param event event
    this._doNormalEvent = function(event)
        if this.mode == 3 or true then
            if event.name == "char" then
                --return this
                this.text = this.text:sub(1, this.cursorOffset) .. event.param1 .. this.text:sub(this.cursorOffset + 1)
                this.cursorOffset = this.cursorOffset + 1
                --TODO Only recalculate Text!!!
                this.recalculate()
                this.repaint("this")
            elseif event.name == "key" or event.name == "key_up" then
                local key = keys.getName(event.param1)
                if key == "backspace" then
                    if this.cursorOffset > 0 then
                        this.text = this.text:sub(1, this.cursorOffset - 1) .. this.text:sub(this.cursorOffset + 1)
                        this.cursorOffset = this.cursorOffset - 1
                        --TODO Only recalculate Text!!!
                        this.recalculate()
                        this.repaint("this")
                    end
                    return this
                elseif key == "delete" then
                    if this.cursorOffset < this.text:len() then
                        this.text = this.text:sub(1, this.cursorOffset) .. this.text:sub(this.cursorOffset + 2)
                        --TODO Only recalculate Text!!!
                        this.recalculate()
                        this.repaint("this")
                    end
                elseif key == "end" then
                    this.cursorOffset = this.text:len()
                    --TODO Only recalculate Text!!!
                    this.recalculate()
                    this.repaint("this")
                    return this
                elseif key == "left" then
                    this.cursorOffset = math.max(0, this.cursorOffset - 1)
                    --TODO Only recalculate Text!!!
                    this.recalculate()
                    this.repaint("this")
                    return this
                elseif key == "right" then
                    this.cursorOffset = math.min(this.text:len(), this.cursorOffset + 1)
                    --TODO Only recalculate Text!!!
                    this.recalculate()
                    this.repaint("this")
                    return this
                elseif key == " " or key:gsub("%g", "key") == "key" then
                    return this
                end
            end
        end
    end

    return this
end
