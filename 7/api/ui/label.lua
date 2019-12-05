---@return label
function new(parent, text, style, x, y, w, h)
    ---@class label:element
    local this = ui.element.new(parent, x, y, w, h)

    ---@type style.label
    this.style = style

    this.text = text

    this.recalculate = function()
        ---@type style.label.theme
        local theme = nil
        if this.mode == 2 then
            theme = this.style.disabledTheme
        else
            theme = this.style.normalTheme
        end
        ui.buffer.text(
            this.buffer,
            this.text,
            theme.textColor,
            theme.backgroundColor,
            this.style.alignment,
            false,
            true,
            false
        )
    end

    this.recalculate()

    return this
end
