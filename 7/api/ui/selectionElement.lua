---@param element element
---@param left selectionElement|optional
---@param up selectionElement|optional
---@param right selectionElement|optional
---@param down selectionElement|optional
---@return selectionElement
function new(element, left, up, right, down)
    ---@class selectionElement
    local this = {element = element, left = left, up = up, right = right, down = down}
    return this
end
