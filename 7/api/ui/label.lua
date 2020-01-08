---Create a new label
---@return label
function new(parent, text, style, x, y, w, h)
    ---A simple label without function
    ---@class label:element
    local this = ui.element.new(parent, x, y, w, h)
    this.style = style
    this.text = text
    function this:recalculate()
        local theme = nil
        if self.mode == 2 then
            theme = self.style.dTheme
        else
            theme = self.style.nTheme
        end
        ui.buffer.text(self.buffer, self.text, theme.tC, theme.tBG, self.style.align, false, true, false)
    end
    ---Recalculate the buffer of this element
    ---@return nil
    this:recalculate()
    return this
end
