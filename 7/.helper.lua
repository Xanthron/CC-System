ui = {}

ui.buffer = {}
---Create a new buffer
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param t string|optional
---@param tC string|optional
---@param tBG string|optional
---@return buffer
function ui.buffer.new(x, y, w, h, t, tC, tBG)
end
---Draws a label in buffer
---@param buffer buffer
---@param t string
---@param tC color
---@param tBG color
---@param align alignment
---@param space char
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
---@return nil
function ui.buffer.labelBox(buffer, t, tC, tBG, align, space, left, top, right, bottom)
end
---Draws a border in buffer
---@param buffer buffer
---@param b border
---@param bC color
---@param bBG color
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
function ui.buffer.borderBox(buffer, b, bC, bBG, left, top, right, bottom)
end
---Draws a label with border in buffer
---@param buffer buffer
---@param t string
---@param tC color
---@param tBG color
---@param b border
---@param bC color
---@param bBG color
---@param align alignment
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
---@return nil
function ui.buffer.borderLabelBox(buffer, t, tC, tBG, b, bC, bBG, align, left, top, right, bottom)
end
---Fills the buffer with one char a the text color and a background color
---@param buffer buffer
---@param t char
---@param tC color
---@param tBG color
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
---@return nil
function ui.buffer.fill(buffer, t, tC, tBG, left, top, right, bottom)
end
---Draws a text in buffer
---@param buffer buffer
---@param t string
---@param tC color
---@param tBG color
---@param align alignment
---@param scaleW boolean
---@param scaleH boolean
---@param richText boolean
---@param left integer|optional
---@param top integer|optional
---@param right integer|optional
---@param bottom integer|optional
---@return nil
function ui.buffer.text(buffer, t, tC, tBG, align, scaleW, scaleH, richText, left, top, right, bottom)
end

ui.button = {}
---@param text string
--TODO remove
---@param func function
---@param style style.button
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return button
function ui.button.new(parent, text, func, style, x, y, w, h)
end

ui.element = {}
---Create a new element
---@param parent element
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param name string
---@return element
function ui.element.new(parent, name, x, y, w, h)
end

ui.event = {}
---Create a new event container
---@return event
function ui.event.new()
end

ui.inputField = {}
---Create a new inputField
---@param parent element
---@param label string|nil
---@param text string
--TODO remove multiline, it is not in use
---@param multiLine boolean
--TODO remove onSubmit
---@param onSubmit function
---@param style style.inputField
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return inputField
function ui.inputField.new(parent, label, text, multiLine, onSubmit, style, x, y, w, h)
end

ui.label = {}
---Create a new label
---@param parent element
---@param text string
---@param style style.label
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return label
function ui.label.new(parent, text, style, x, y, w, h)
end

ui.padding = {}
---Create a new padding
---@param left integer
---@param top integer
---@param right integer
---@param bottom integer
---@return padding
function ui.padding.new(left, top, right, bottom)
end

ui.parallelElement = {}
---Create a new parallelElement
---@param caller parallelManager|nil
---@param func function
---@param data table
---@return parallelElement
function ui.parallelElement.new(caller, func, data)
end

ui.parallelManager = {}
---Create a new parallelManager
---@return parallelManager
function ui.parallelManager.new()
end

ui.rect = {}
---Create a new rect
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return rect
function ui.rect.new(x, y, w, h)
end
---Overlaps two unpacked rect
---@param x1 integer
---@param y1 integer
---@param w1 integer
---@param h1 integer
---@param x2 integer
---@param y2 integer
---@param w2 integer
---@param h2 integer
---@return integer, integer, integer, integer
function ui.rect.overlaps(x1, y1, w1, h1, x2, y2, w2, h2)
end

ui.repeatItem = {}
---@param startRepeatSpeed number
---@param endRepeatSpeed number
---@param repeatSpeedIncrement number
---@return repeatItem
function ui.repeatItem.new(startRepeatSpeed, endRepeatSpeed, repeatSpeedIncrement)
end

ui.scrollView = {}
---@param parent element
---@param label string|nil
---@param mode "1 = vertical, horizontal"|"2 = non"|"3 = vertical"|"4 = horizontal"
---@param style style.scrollView
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return scrollView
function ui.scrollView.new(parent, label, mode, style, x, y, w, h)
end

ui.selectionElement = {}
---@param element element
---@param left selectionElement|optional
---@param up selectionElement|optional
---@param right selectionElement|optional
---@param down selectionElement|optional
---@return selectionElement
function ui.selectionElement.new(element, left, up, right, down)
end

ui.selectionGroup = {}
---Create a new selectionGroup
---@param previous selectionGroup|optional
---@param next selectionGroup|optional
---@param listener function|optional
---@return selectionGroup
function ui.selectionGroup.new(previous, next, listener)
end

ui.selectionManager = {}
---Create a new selectionManager
---@return selectionManager
function ui.selectionManager.new()
end
---Select an element by direction
---@param selectionGroup selectionGroup
---@param direction string
---@param source string
---@return nil
function ui.selectionManager._select(selectionGroup, direction, source)
end
---Switch the selection in a manager
---@param selectionManager selectionManager
---@param selectionGroup selectionGroup
---@param source string
---@param ... any
---@return nil
function ui.selectionManager._switch(selectionManager, selectionGroup, source, ...)
end
ui.slider = {}
---@param parent element
--TODO remove
---@param onValueChange function
---@param orientation "1 = vertical"|"2 = horizontal"
---@param startValue integer
---@param endValue integer
---@param size integer
---@param style style.slider
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return slider
function ui.slider.new(parent, onValueChange, orientation, startValue, endValue, size, style, x, y, w, h)
end

ui.textBox = {}
---@param parent element
---@param label string|nil
---@param text string
---@param style style.textBox
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return textBox
function ui.textBox.new(parent, label, text, style, x, y, w, h)
end

ui.toggleButton = {}
---@param parent element
--TODO edit to label?
---@param text string
---@param checked boolean
--TODO remove
---@param func function
---@param style style.toggleButton
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return toggle
function ui.toggleButton.new(parent, text, checked, func, style, x, y, w, h)
end

ui.uiManager = {}
---Create a new uiManager
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return uiManager
function ui.uiManager.new(x, y, w, h)
end

---@class selectElement
local select = {}
---@type element
select.left, select.up, select.right, select.down = nil
