---Create a new label
---@param parent element
---@param text string
---@param style style.label
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return label
function new(parent, text, style, x, y, w, h)
    ---A simple label without function
    ---@class label:element
    local this = ui.element.new(parent, x, y, w, h)

    ---@type style.label
    this.style = style
    ---@type string
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
