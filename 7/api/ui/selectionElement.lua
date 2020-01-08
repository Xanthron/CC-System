---@param element element
---@param left selectionElement|optional
---@param up selectionElement|optional
---@param right selectionElement|optional
---@param down selectionElement|optional
---@return selectionElement
function new(element, left, up, right, down)
    ---@class selectionElement
    local this = {}

    ---@type element
    this.element = element
    ---@type selectionElement
    this.left = left
    ---@type selectionElement
    this.up = up
    ---@type selectionElement
    this.right = right
    ---@type selectionElement
    this.down = down

    return this
end
