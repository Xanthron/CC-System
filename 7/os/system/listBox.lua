local args = ...

local x, y, w, h
if args.x then
    x = args.x
    y = args.y
    w = args.w
    h = args.h
else
    local x, y = 1, 1
    local w, h = term.getSize()
end

local width, height = term.getSize()

local label = args.label
local buttons = args.buttons
local select = args.select or not term.isColor()
local ids = args.ids or {}

local listBoxTheme = args.theme or theme.listBox

local left = #listBoxTheme.normalTheme.border[4]
local top = #listBoxTheme.normalTheme.border[2]
local right = #listBoxTheme.normalTheme.border[6]
local bottom = #listBoxTheme.normalTheme.border[8]
if not w then
    w = 0
    for _, value in ipairs(buttons) do
        if type(value) == "string" then
            w = math.max(w, value:len())
        else
            w = math.max(w, value.name:len() + 2)
        end
    end
    w = w + #theme.listButton.normalTheme.border[4] + #theme.listButton.normalTheme.border[6] + left + right + 1
end
if not h then
    h = #buttons + top + bottom
end

---@type uiManager
local manager = ui.uiManager.new(args.manager.getGlobalRect())
--manager.buffer = assets.extension.copyTable(args.manager.buffer)
manager.buffer.contract(args.manager.buffer)

local ret = 0

local createListView
createListView = function(buttons, x, y, w, h, label, id)
    ---@type scrollView
    local listView = ui.scrollView.new(manager, label, 3, listBoxTheme, x, y, w, h)
    listView.id = id

    local buttonSelectionElements = {}
    local container = listView.getContainer()
    for i, value in ipairs(buttons) do
        if type(value) == "string" then
            local buttonElement = ui.button.new(container, value, nil, theme.listButton, x + left, y + top + i - 1, w - left - right, 1)
            buttonElement.id = i
            buttonElement._onClick = function(event)
                manager.exit()
            end
            table.insert(buttonSelectionElements, listView.selectionGroup.addNewSelectionElement(buttonElement))
        else
            ---@type button
            local buttonElement = ui.button.new(container, value.name .. " >", nil, theme.listButton, x + left, y + top + i - 1, w - left - right, 1)
            buttonElement.id = i
            buttonElement._onClick = function(event)
                table.insert(ids, i)

                local buttons = buttons[i]

                local w = 0
                for _, value in ipairs(buttons) do
                    if type(value) == "string" then
                        w = math.max(w, value:len())
                    else
                        w = math.max(w, value.name:len() + 2)
                    end
                end
                w = w + #theme.listButton.normalTheme.border[4] + #theme.listButton.normalTheme.border[6] + left + right + 1
                local h = #buttons + top + bottom

                local x = math.max(1, math.min(buttonElement.getGlobalPosX() + buttonElement.getWidth() - right - 1, manager.getWidth() - w + 1))
                local y = math.max(1, math.min(buttonElement.getGlobalPosY() - 1, height - h + 1))

                createListView(buttons, x, y, w, h, "", listView.id + 1)
                manager.draw()
            end
            table.insert(buttonSelectionElements, listView.selectionGroup.addNewSelectionElement(buttonElement))
        end
    end
    for i, value in ipairs(buttonSelectionElements) do
        buttonSelectionElements[i].up = buttonSelectionElements[i - 1]
        buttonSelectionElements[i].down = buttonSelectionElements[i + 1]
    end

    listView.selectionGroup.listener = function(eventName, source, ...)
        local this = listView
        if eventName == "key_up" then
            -- elseif eventName == "mouse" then
            --     local event = ...
            --     if event.name == "mouse_up" and (event.param2 < x or event.param2 > x + w or event.param3 < y or event.param3 > y + h) then
            --         ret = 0
            --         manager.exit()
            --     end
            local key = keys.getName(...)
            if key == "left" then
                if #ids > 0 then
                    ret = -1
                    manager.exit()
                    return false
                end
            elseif key == "right" then
                return false
            end
        elseif eventName == "selection_lose_focus" then
            local currentElement, newElement = ...
            if newElement.id > currentElement.id then
                this.setParent(nil)
                manager.draw()
            end
        elseif eventName == "selection_get_focus" then
            if this.selectionGroup.currentSelectionElement == nil then
                local index = 0
                if this._elements[2] then
                    index = index + 1
                end
                if this._elements[3] then
                    index = index + 1
                end
                if #this.selectionGroup.selectionElements > index then
                    local selectionElement = this.selectionGroup.selectionElements[index + 1]
                    local element = selectionElement.element
                    this.selectionGroup.currentSelectionElement = selectionElement
                    if this.selectionGroup.listener("selection_get_focus", "key", nil, element) ~= false then
                        if element and element.mode ~= 3 then
                            element.mode = 3
                            if not element._inAnimation then
                                element.recalculate()
                                element.repaint("this")
                            end
                        end
                        return false
                    end
                end
            end

            local currentElement, newElement = ...
            if newElement and (source == "key" or source == "code") then
                this.focusElement(newElement)
            end
            this.mode = 3
            this.recalculate()
            this.repaint("this")
            if source == "mouse" then
                return false
            end
        elseif eventName == "selection_reselect" then
            if source == "key" then
                local element = ...
                this.focusElement(element)
            end
        elseif eventName == "selection_change" then
            ---@type element
            local currentElement, newElement = ...
            if newElement == this or newElement == this._elements[2] or newElement == this._elements[3] then
                if currentElement and currentElement.mode == 3 then
                    currentElement.mode = 1
                    currentElement.recalculate()
                    currentElement.repaint("this")
                end
                return false
            elseif newElement and (source == "key" or source == "code") then
                this.focusElement(newElement)
            end
        end
    end

    listView.selectionGroup.currentSelectionElement = buttonSelectionElements[1]
    manager.selectionManager.addSelectionGroup(listView.selectionGroup)
    if select then
        manager.selectionManager.setCurrentSelectionGroup(listView.selectionGroup)
    else
        manager.selectionManager._currentSelectionGroup = listView.selectionGroup
    end
end
createListView(buttons, x, y, w, h, label, 1)

args.manager.draw()
manager.draw()
manager.execute()
return ret
