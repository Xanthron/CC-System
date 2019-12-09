---@param parent element
---@param label string
---@param text string
---@param onSubmit function
---@param style style.inputField
function new(parent, label, text, onSubmit, style, x, y, w, h)
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

        if this.mode == 1 then
            theme = this.style.normalTheme
            labelTheme = this.style.label.normalTheme
        elseif this.mode == 2 then
            theme = this.style.disabledTheme
            labelTheme = this.style.label.disabledTheme
        else
            theme = this.style.selectedTheme
            labelTheme = this.style.label.normalTheme
        end

        ui.buffer.borderBox(this.buffer, theme.border, theme.borderColor, theme.borderBackgroundColor)
        if this.label then
            local yPos = math.max(0, math.floor((#theme.border[2] - 1) / 2))
            ui.buffer.labelBox(
                this.buffer,
                this.label,
                labelTheme.textColor,
                labelTheme.textBackgroundColor,
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
            this.text,
            theme,
            theme.textColor,
            theme.textBackgroundColor,
            1,
            theme.border[5],
            #theme.border[4],
            theme.border[2],
            theme.border[6],
            theme.border[8]
        )
    end
    this.recalculate()

    return this
end
