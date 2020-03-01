ui.text = {}
---Create a new label
---@param parent element
---@param text string
---@param style style.label
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param key string|optional
---@return label
function ui.text.new(parent, text, style, x, y, w, h, key)
    ---A simple label without function
    ---@class text:element
    local this = ui.element.new(parent, "text", x, y, w, h, key)

    ---@type style.label
    this.style = style
    ---@type string
    this.text = text

    this.richText = true
    this.scaleW = false
    this.scaleH = true

    function this:recalculate()
        local theme = nil
        if self.mode == 2 then
            theme = self.style.dTheme
        else
            theme = self.style.nTheme
        end
        ui.buffer.text(self.buffer, self.text, theme.tC, theme.tBG, self.style.align, this.scaleW, this.scaleH, self.richText)
    end
    ---Recalculate the buffer of this element
    ---@return nil
    this:recalculate()
    return this
end
