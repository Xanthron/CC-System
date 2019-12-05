--- Create a new `selectionElement`.
---@param element element
---@param left element
---@param up element
---@param right element
---@param down element
function new(element, left, up, right, down)
    --- A container for storing information which `element` should be selected when pressing left, up, right or down.
    ---@class selectionElement
    local this = {element = element, left = left, up = up, right = right, down = down}
    return this
end
