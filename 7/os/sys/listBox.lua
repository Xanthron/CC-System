local args = ...
local _x, _y, _w, _h = args.manager:getGlobalRect()
args.anchor = args.anchor or 1
args.listBoxStyle = args.listBoxStyle or theme.sView2
args.listButtonStyle = args.listButtonStyle or theme.button3
args.select = args.select or not term.isColor()
local select = args.select
local listBoxLeft, listBoxTop, listBoxRight, listBoxBottom = #args.listBoxStyle.nTheme.b[4], #args.listBoxStyle.nTheme.b[2], #args.listBoxStyle.nTheme.b[6], #args.listBoxStyle.nTheme.b[8]
local listButtonLeft, listButtonRight = #args.listButtonStyle.nTheme.b[4], #args.listButtonStyle.nTheme.b[6]
local borderW, borderH = listButtonLeft + listButtonRight + listBoxLeft + listBoxRight, listBoxTop + listBoxBottom
local indexes = {}
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
local function setListBox(manager, listBox, buttons, indexes, x, y, w, h)
    listBox:setGlobalRect(x, y, w, h)
    local currentButtons = buttons
    for i = 1, #indexes do
        currentButtons = currentButtons[indexes[i]]
    end
    listBox:clear()
    local container = listBox:getContainer()
    local elements = {}
    if #indexes > 0 then
        local element = ui.button.new(container, " <<<", args.listButtonStyle, args.x + listBoxLeft, args.y + listBoxTop, args.w - listBoxLeft - listBoxRight, 1)
        function element:onClick(event)
            local select = true
            if event.name == "mouse_up" then
                select = false
            end
            manager:callFunction(
                function()
                    manager.parallelManager:removeFunction(element.animation)
                    table.remove(indexes, #indexes)
                    local button = buttons
                    for i = 1, #indexes do
                        button = button[indexes[i]]
                    end
                    local x, y, w, h = listBox:getGlobalRect()
                    x, w = getHorizontal(button, x, borderW, args.anchor)
                    y, h = getVertical(button, y, borderH + math.min(#indexes, 1), args.anchor)
                    setListBox(manager, listBox, buttons, indexes, x, y, w, h)
                    if select then
                        manager.selectionManager:select(listBox.selectionGroup.current, "code", 3)
                    end
                    manager:recalculate()
                    manager:draw()
                end
            )
        end
        table.insert(elements, element)
    end
    for i = 1, #currentButtons do
        local button = currentButtons[i]
        local x, y, w, h = args.x + listBoxLeft, args.y + i - 1 + listBoxTop + math.min(#indexes, 1), args.w - listBoxLeft - listBoxRight, 1
        if type(button) == "table" then
            local element = ui.button.new(container, button.name .. " >", args.listButtonStyle, x, y, w, h)
            function element:onClick(event)
                local select = true
                if event.name == "mouse_up" then
                    select = false
                end
                manager:callFunction(
                    function()
                        manager.parallelManager:removeFunction(element.animation)
                        table.insert(indexes, i)
                        local x, y, w, h = listBox:getGlobalRect()
                        x, w = getHorizontal(button, x, borderW, args.anchor)
                        y, h = getVertical(button, y, borderH + 1, args.anchor)
                        setListBox(manager, listBox, buttons, indexes, x, y, w, h)
                        if select then
                            manager.selectionManager:select(listBox.selectionGroup.current)
                        end
                        manager:recalculate()
                        manager:draw()
                    end
                )
            end
            table.insert(elements, element)
        else
            if button == "-" then
                local element = ui.element.new(container, "image", x, y, w, h)
                for i = 1, w do
                    element.buffer.text[i] = "-"
                    element.buffer.textColor[i] = args.listButtonStyle.nTheme.tC
                    element.buffer.textBackgroundColor[i] = args.listButtonStyle.nTheme.tBG
                end
                element.buffer.text[1] = " "
                element.buffer.text[w] = " "
            elseif button ~= "" then
                local element = ui.button.new(container, button, args.listButtonStyle, x, y, w, h)
                function element:onClick(event)
                    table.insert(indexes, i)
                    select = (event.name ~= "mouse_up")
                    manager:exit()
                end
                table.insert(elements, element)
                if button:sub(1, 1) == "*" then
                    element.text = button:sub(2)
                    element.mode = 2
                    element:recalculate()
                end
            end
        end
    end
    for i, value in ipairs(elements) do
        listBox.selectionGroup:addElement(elements[i], nil, elements[i - 1], nil, elements[i + 1])
    end
    listBox:resetLayout()
    listBox:recalculate()
    listBox.selectionGroup.current = elements[1]
end
if not args.w then
    args.x, args.w = getHorizontal(args.buttons, args.x, borderW, args.anchor)
end
if not args.h then
    args.y, args.h = getVertical(args.buttons, args.y, borderH, args.anchor)
end
local manager = ui.uiManager.new(_x, _y, _w, _h)
manager.recalculate = function()
    manager.buffer:contract(args.manager.buffer)
end
manager:recalculate()
local listBox = ui.scrollView.new(manager, args.label, 3, args.listBoxStyle, args.x, args.y, args.w, args.h)
setListBox(manager, listBox, args.buttons, indexes, args.x, args.y, args.w, args.h)
function listBox.selectionGroup:listener(name, source, ...)
    if name == "key_up" then
        local key = keys.getName(...)
        if key == "tab" or key == "e" or key == "q" then
            select = true
            manager:exit()
        end
    elseif name == "mouse" then
        local event = ...
        if event.name == "mouse_click" or event.name == "monitor_touch" then
            local x, y, w, h = listBox:getGlobalRect()
            if event.param2 < x or event.param2 > x + w or event.param3 < y or event.param3 > y + h then
                select = false
                manager:exit()
            end
        end
    end
end
manager.selectionManager:addGroup(listBox.selectionGroup)
local mode = 3
if select == false then
    mode = 1
end
manager.selectionManager:select(listBox.selectionGroup, "code", mode)
manager:draw()
manager:execute()
local name = args.buttons[indexes[1]]
for i = 2, #indexes do
    name = name[indexes[i]]
end
return name, indexes, select
