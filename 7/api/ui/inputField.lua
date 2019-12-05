---@param parent element
---@param text string
---@param onSubmit function
---@param style style.inputField
function new(parent, text, onSubmit, style, x, y, w, h)
    local this = ui.element.new(parent, x, y, w, h)

    this.style = style
    this.text = text

    this.recalculate = function()
        if this.mode == 3 then
        end
    end

    return this
end
