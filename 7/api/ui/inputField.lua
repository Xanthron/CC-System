---@param parent element
---@param label string
---@param text string
---@param onSubmit function
---@param style style.inputField
function new(parent, label, text, onSubmit, style, x, y, w, h)
    ---@class inputField:element
    local this = ui.element.new(parent, x, y, w, h)

    this.style = style
    this.text = text
    this.label = label

    this.cursorOffset = 0
    if text then
        this.cursorOffset = text:len()
    end

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
        if this.mode == 3 then
            if event.name == "char" then
                return this
            elseif event.name == "key" or event.name == "key_up" then
                local key = keys.getName(event.param1)
                if key == " " or key:gsub("%g", "key") == "key" then
                    return this
                end
            end
        end
    end

    return this
end
