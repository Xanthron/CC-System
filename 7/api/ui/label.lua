function new(parent, text, style, x, y, w, h)
    local this = ui.element.new(parent, x, y, w, h)
    this.style = style
    this.text = text
    this.recalculate = function()
        local theme = nil
        if this.mode == 2 then
            theme = this.style.dTheme
        else
            theme = this.style.nTheme
        end
        ui.buffer.text(this.buffer, this.text, theme.tC, theme.tBG, this.style.align, false, true, false)
    end
    this.recalculate()
    return this
end
