---need:
---  x
---  y
---  manager
---  buttons
---
---optional:
---  anchor
---  w
---  h
---  select
---  listBoxStyle
---  listButtonStyle
---  label
local args = ...

local _x, _y, _w, _h = args.manager.getGlobalRect()

args.anchor = args.anchor or 1
args.listBoxStyle = args.listBoxStyle or theme.listBox
---@type style.button
args.listButtonStyle = args.listButtonStyle or theme.listButton
args.select = args.select or not term.isColor()

local listBoxLeft, listBoxTop, listBoxRight, listBoxBottom = #args.listBoxStyle.normalTheme.border[4], #args.listBoxStyle.normalTheme.border[2], #args.listBoxStyle.normalTheme.border[6], #args.listBoxStyle.normalTheme.border[8]
local listButtonLeft, listButtonRight = #args.listButtonStyle.normalTheme.border[4], #args.listButtonStyle.normalTheme.border[6]
local borderW, borderH = listButtonLeft + listButtonRight + listBoxLeft + listBoxRight, listBoxTop + listBoxBottom
local indexes = {}

---Function
local function getHorizontal(buttons, posX, border, anchor)
    local x = posX
    local w = 1
    for i = 1, #buttons do
        local button = buttons[i]
        if type(button) == "string" then
            local add = 0
            if button:sub(1, 1) == "*" then
                add = add - 1
            end
            w = math.max(w, button:len() + add)
        else
            w = math.max(w, button.name:len() + 2)
        end
    end
    w = w + border
    if anchor == 2 or anchor == 5 or anchor == 8 then
        x = math.min(_x, math.max(_x + _w - w, math.floor(x - w / 2)))
    elseif anchor == 3 or anchor == 6 or anchor == 9 then
        x = math.min(_x, math.max(_x + _w - w, x - w))
    end
    return x, w
end

local function getVertical(buttons, posY, border, anchor)
    local y = posY
    local h = #buttons + border
    if anchor == 4 or anchor == 5 or anchor == 6 then
        y = math.min(_y, math.max(_y + _h - h, math.floor(y - h / 2)))
    elseif anchor == 7 or anchor == 8 or anchor == 9 then
        y = math.min(_y, math.max(_y + _h - h, y - h))
    end
    return y, h
end

local function clearListBox(listBox)
    local container = listBox.getContainer()
    for i = 1, #container._elements do
        table.remove(container._elements, 1)
    end
    for i = 1, #listBox.selectionGroup.selectionElements do
        listBox.selectionGroup.selectionElements[i] = nil
    end
end
---@param manager uiManager
---@param listBox scrollView
---@param buttons string[]|table[]
local function setListBox(manager, listBox, buttons, indexes, x, y, w, h)
    listBox.setGlobalRect(x, y, w, h)
    local currentButtons = buttons
    for i = 1, #indexes do
        currentButtons = currentButtons[indexes[i]]
    end

    clearListBox(listBox)

    local container = listBox.getContainer()
    local selectionElements = {}
    if #indexes > 0 then
        ---@type button
        local element = ui.button.new(container, " <<<", nil, args.listButtonStyle, args.x + listBoxLeft, args.y + listBoxTop, args.w - listBoxLeft - listBoxRight, 1)
        element._onClick = function(event)
            local select = true
            if event.name == "mouse_up" then
                select = false
            end
            manager.callFunction(
                function()
                    manager.parallelManager.removeFunction(element._pressAnimation)
                    table.remove(indexes, #indexes)
                    local button = buttons
                    for i = 1, #indexes do
                        button = button[indexes[i]]
                    end
                    local x, y, w, h = listBox.getGlobalRect()
                    x, w = getHorizontal(button, x, borderW, args.anchor)
                    y, h = getVertical(button, y, borderH + math.min(#indexes, 1), args.anchor)
                    setListBox(manager, listBox, buttons, indexes, x, y, w, h)
                    if select then
                        manager.selectionManager.select(listBox.selectionGroup.currentSelectionElement.element)
                    end
                    manager.recalculate()
                    manager.draw()
                end
            )
        end
        table.insert(selectionElements, listBox.selectionGroup.addNewSelectionElement(element))
    end
    for i = 1, #currentButtons do
        local button = currentButtons[i]
        local x, y, w, h = args.x + listBoxLeft, args.y + i - 1 + listBoxTop + math.min(#indexes, 1), args.w - listBoxLeft - listBoxRight, 1
        if type(button) == "table" then
            ---@type button
            local element = ui.button.new(container, button.name .. " >", nil, args.listButtonStyle, x, y, w, h)
            element._onClick = function(event)
                local select = true
                if event.name == "mouse_up" then
                    select = false
                end
                manager.callFunction(
                    function()
                        manager.parallelManager.removeFunction(element._pressAnimation)
                        table.insert(indexes, i)
                        local x, y, w, h = listBox.getGlobalRect()
                        x, w = getHorizontal(button, x, borderW, args.anchor)
                        y, h = getVertical(button, y, borderH + 1, args.anchor)
                        setListBox(manager, listBox, buttons, indexes, x, y, w, h)
                        if select then
                            manager.selectionManager.select(listBox.selectionGroup.currentSelectionElement.element)
                        end
                        manager.recalculate()
                        manager.draw()
                    end
                )
            end
            table.insert(selectionElements, listBox.selectionGroup.addNewSelectionElement(element))
        else
            if button == "-" then
                ---@type element
                local element = ui.element.new(container, x, y, w, h)
                for i = 1, w do
                    element.buffer.text[i] = "-"
                    element.buffer.textColor[i] = args.listButtonStyle.normalTheme.textColor
                    element.buffer.textBackgroundColor[i] = args.listButtonStyle.normalTheme.textBackgroundColor
                end
                element.buffer.text[1] = " "
                element.buffer.text[w] = " "
            elseif button ~= "" then
                ---@type button
                local element = ui.button.new(container, button, nil, args.listButtonStyle, x, y, w, h)
                element._onClick = function()
                    table.insert(indexes, i)
                    manager.exit()
                end
                table.insert(selectionElements, listBox.selectionGroup.addNewSelectionElement(element))
                if button:sub(1, 1) == "*" then
                    element.text = button:sub(2)
                    element.mode = 2
                    element.recalculate()
                end
            end
        end
    end

    for i, value in ipairs(selectionElements) do
        selectionElements[i].up = selectionElements[i - 1]
        selectionElements[i].down = selectionElements[i + 1]
    end

    listBox.resetLayout()
    listBox.recalculate()

    listBox.selectionGroup.currentSelectionElement = selectionElements[1]
end

---Setup
if not args.w then
    args.x, args.w = getHorizontal(args.buttons, args.x, borderW, args.anchor)
end
if not args.h then
    args.y, args.h = getVertical(args.buttons, args.y, borderH, args.anchor)
end

---@type uiManager
local manager = ui.uiManager.new(_x, _y, _w, _h)
manager.recalculate = function()
    manager.buffer.contract(args.manager.buffer)
end
manager.recalculate()
---@type scrollView
local listBox = ui.scrollView.new(manager, args.label, 3, args.listBoxStyle, args.x, args.y, args.w, args.h)
setListBox(manager, listBox, args.buttons, indexes, args.x, args.y, args.w, args.h)
listBox.selectionGroup.listener = function(name, source, ...)
    if name == "key_up" then
        local key = keys.getName(...)
        if key == "tab" or key == "e" or key == "q" then
            manager.exit()
        end
    elseif name == "mouse" then
        ---@type event
        local event = ...
        if event.name == "mouse_click" then
            local x, y, w, h = listBox.getGlobalRect()
            if event.param2 < x or event.param2 > x + w or event.param3 < y or event.param3 > y + h then
                manager.exit()
            end
        end
    end
end

manager.selectionManager.addSelectionGroup(listBox.selectionGroup)
if args.select then
    manager.selectionManager.setCurrentSelectionGroup(listBox.selectionGroup)
else
    manager.selectionManager._currentSelectionGroup = listBox.selectionGroup
end

manager.draw()
manager.execute()

local name = args.buttons[indexes[1]]
for i = 2, #indexes do
    name = name[indexes[i]]
end

return name, indexes
