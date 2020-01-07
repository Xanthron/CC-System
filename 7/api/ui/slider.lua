function new(parent, onValueChange, orientation, startValue, endValue, size, style, x, y, w, h)
    local this = ui.element.new(parent, x, y, w, h)
    this.style = style
    this.orientation = orientation
    this.pressedButton = 0
    this.repeatItem = ui.repeatItem.new(0.8, 0.05, 0.7)
    this.startValue = startValue
    this.endValue = endValue
    this.size = size
    this.value = startValue
    this.recalculate = function()
        local buffer = this.buffer
        local theme = {}
        local mode = this.mode
        if mode == 2 then
            theme = this.style.dTheme
        else
            theme = this.style.nTheme
        end
        local totalSize = this.endValue - this.startValue
        local value = math.max(0, (this.value) / math.max(1, (totalSize + this.startValue - this.size)))
        if this.orientation == 1 then
            local height = this.buffer.rect.h
            local barHeight
            local offset
            if totalSize <= this.size then
                barHeight = height - 2
                offset = 1
            else
                barHeight = math.max(1, math.min(math.floor(size / (totalSize + this.startValue) * (height - 2)), height - math.min(4, totalSize - size + 2)))
                offset = math.max(0, math.floor((height - 3 - barHeight) * value)) + 1
                if value > 0 then
                    offset = offset + 1
                end
            end
            local width = #theme.sliderT
            if this.buffer.rect.w ~= width then
            end
            local index = 1
            if mode == 2 or value == 0 then
                for i = 1, width do
                    buffer.text[index] = theme.buttonP.dTheme.t[i]
                    buffer.textColor[index] = theme.buttonP.dTheme.tC[i]
                    buffer.textBackgroundColor[index] = theme.buttonP.dTheme.tBG[i]
                    index = index + 1
                end
            else
                if this.pressedButton == 1 and this.mode == 4 then
                    for i = 1, width do
                        buffer.text[index] = theme.buttonP.sTheme.t[i]
                        buffer.textColor[index] = theme.buttonP.sTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonP.sTheme.tBG[i]
                        index = index + 1
                    end
                else
                    for i = 1, width do
                        buffer.text[index] = theme.buttonP.nTheme.t[i]
                        buffer.textColor[index] = theme.buttonP.nTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonP.nTheme.tBG[i]
                        index = index + 1
                    end
                end
            end
            for i = 2, this.buffer.rect.h - 1 do
                for j = 1, width do
                    if i > offset and i <= offset + barHeight then
                        buffer.text[index] = theme.sliderT[j]
                        buffer.textColor[index] = theme.sliderTC[j]
                        buffer.textBackgroundColor[index] = theme.sliderTBG[j]
                        index = index + 1
                    else
                        buffer.text[index] = theme.handleL[j]
                        buffer.textColor[index] = theme.handleLC[j]
                        buffer.textBackgroundColor[index] = theme.handleLBG[j]
                        index = index + 1
                    end
                end
            end
            if mode == 2 or value == 1 or totalSize - this.size <= 0 then
                for i = 1, width do
                    buffer.text[index] = theme.buttonN.dTheme.t[i]
                    buffer.textColor[index] = theme.buttonN.dTheme.tC[i]
                    buffer.textBackgroundColor[index] = theme.buttonN.dTheme.tBG[i]
                    index = index + 1
                end
            else
                if this.pressedButton == 2 and this.mode == 4 then
                    for i = 1, width do
                        buffer.text[index] = theme.buttonN.sTheme.t[i]
                        buffer.textColor[index] = theme.buttonN.sTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonN.sTheme.tBG[i]
                        index = index + 1
                    end
                else
                    for i = 1, width do
                        buffer.text[index] = theme.buttonN.nTheme.t[i]
                        buffer.textColor[index] = theme.buttonN.nTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonN.nTheme.tBG[i]
                        index = index + 1
                    end
                end
            end
        else
            local width = this.buffer.rect.w
            local barWidth
            local offset
            if totalSize <= this.size then
                barWidth = width - 2
                offset = 1
            else
                barWidth = math.max(1, math.min(math.floor(size / (totalSize + this.startValue) * (width - 2)), width - math.min(4, totalSize - size + 2)))
                offset = math.max(0, math.floor((width - 3 - barWidth) * value)) + 1
                if value > 0 then
                    offset = offset + 1
                end
            end
            local height = #theme.sliderT
            if this.buffer.rect.h ~= height then
            end
            local index = 1
            if mode == 2 or value == 0 then
                for i = 1, height do
                    buffer.text[index] = theme.buttonP.dTheme.t[i]
                    buffer.textColor[index] = theme.buttonP.dTheme.tC[i]
                    buffer.textBackgroundColor[index] = theme.buttonP.dTheme.tBG[i]
                    index = index + width
                end
            else
                if this.pressedButton == 1 and this.mode == 4 then
                    for i = 1, height do
                        buffer.text[index] = theme.buttonP.sTheme.t[i]
                        buffer.textColor[index] = theme.buttonP.sTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonP.sTheme.tBG[i]
                        index = index + width
                    end
                else
                    for i = 1, height do
                        buffer.text[index] = theme.buttonP.nTheme.t[i]
                        buffer.textColor[index] = theme.buttonP.nTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonP.nTheme.tBG[i]
                        index = index + width
                    end
                end
            end
            index = 2
            for i = 2, width - 1 do
                for j = 1, height do
                    if i > offset and i <= offset + barWidth then
                        buffer.text[index] = theme.sliderT[j]
                        buffer.textColor[index] = theme.sliderTC[j]
                        buffer.textBackgroundColor[index] = theme.sliderTBG[j]
                        index = index + width
                    else
                        buffer.text[index] = theme.handleL[j]
                        buffer.textColor[index] = theme.handleLC[j]
                        buffer.textBackgroundColor[index] = theme.handleLBG[j]
                        index = index + width
                    end
                    index = i + j
                end
            end
            if mode == 2 or value == 1 or totalSize - this.size <= 0 then
                for i = 1, height do
                    buffer.text[index] = theme.buttonN.dTheme.t[i]
                    buffer.textColor[index] = theme.buttonN.dTheme.tC[i]
                    buffer.textBackgroundColor[index] = theme.buttonN.dTheme.tBG[i]
                    index = index + width
                end
            else
                if this.pressedButton == 2 and this.mode == 4 then
                    for i = 1, height do
                        buffer.text[index] = theme.buttonN.sTheme.t[i]
                        buffer.textColor[index] = theme.buttonN.sTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonN.sTheme.tBG[i]
                        index = index + width
                    end
                else
                    for i = 1, height do
                        buffer.text[index] = theme.buttonN.nTheme.t[i]
                        buffer.textColor[index] = theme.buttonN.nTheme.tC[i]
                        buffer.textBackgroundColor[index] = theme.buttonN.nTheme.tBG[i]
                        index = index + width
                    end
                end
            end
        end
    end
    this.recalculate()
    this._onValueChange = nil
    this._repeatButtonPressElement =
        ui.parallelElement.new(
        nil,
        function(data)
            while true do
                if this.mode == 4 and this.repeatItem.call() == true then
                    if this.pressedButton == 1 then
                        if this._onValueChange then
                            this._onValueChange(-1)
                        end
                    else
                        if this._onValueChange then
                            this._onValueChange(1)
                        end
                    end
                end
                sleep(0)
            end
        end,
        {}
    )
    this._doPointerEvent = function(event, x, y, w, h)
        local rectX, rectY, rectW, rectH = this.getGlobalRect()
        x, y, w, h = ui.rect.overlaps(x, y, w, h, rectX, rectY, rectW, rectH)
        if this.orientation == 1 then
            if event.name == "mouse_click" then
                if event.param2 >= x and event.param2 < x + w then
                    if y == rectY and event.param3 == y then
                        this.mode = 4
                        this.pressedButton = 1
                        this.recalculate()
                        this.repaint("this", x, y, w, h)
                        this.getManager().parallelManager.addFunction(this._repeatButtonPressElement)
                        return this
                    elseif y + h == rectY + rectH and event.param3 == y + h - 1 then
                        this.mode = 4
                        this.pressedButton = 2
                        this.recalculate()
                        this.repaint("this", x, y, w, h)
                        this.getManager().parallelManager.addFunction(this._repeatButtonPressElement)
                        return this
                    elseif event.param3 > y and event.param3 < y + h - 1 then
                        this.mode = 4
                        local newPos = event.param3 - rectY - 1
                        local totalSize = this.endValue - this.startValue
                        local newValue = math.floor((newPos / (rectH - 3)) * (totalSize - this.size + this.startValue))
                        this._onValueChange(newValue - this.value)
                        return this
                    end
                end
            elseif event.name == "mouse_drag" then
                if event.param2 >= x and event.param2 < x + w and this.mode == 3 and ((this.pressedButton == 1 and event.param3 == y) or (this.pressedButton == 2 and event.param3 == y + h - 1)) then
                    this.mode = 4
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                    return this
                elseif this.mode == 4 then
                    if this.pressedButton == 0 then
                        local newPos = math.max(0, math.min(rectH - 2, event.param3 - rectY - 1))
                        local totalSize = this.endValue - this.startValue
                        local newValue = math.floor((newPos / (rectH - 3)) * (totalSize - this.size + this.startValue))
                        this._onValueChange(newValue - this.value)
                        return this
                    else
                        this.mode = 3
                        this.recalculate()
                        this.repaint("this", x, y, w, h)
                        return this
                    end
                end
            elseif event.name == "mouse_up" then
                if this.mode == 3 or this.mode == 4 then
                    this.mode = 1
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                    this.repeatItem.reset()
                    this.getManager().parallelManager.removeFunction(this._repeatButtonPressElement)
                    this.pressedButton = 0
                    return this
                end
            end
        else
            if event.name == "mouse_click" then
                if event.param3 >= y and event.param3 < y + h then
                    if x == rectX and event.param2 == x then
                        this.mode = 4
                        this.pressedButton = 1
                        this.recalculate()
                        this.repaint("this", x, y, w, h)
                        this.getManager().parallelManager.addFunction(this._repeatButtonPressElement)
                        return this
                    elseif x + w == rectX + rectW and event.param2 == x + w - 1 then
                        this.mode = 4
                        this.pressedButton = 2
                        this.recalculate()
                        this.repaint("this", x, y, w, h)
                        this.getManager().parallelManager.addFunction(this._repeatButtonPressElement)
                        return this
                    elseif event.param2 > x and event.param2 < x + w - 1 then
                        this.mode = 4
                        local newPos = event.param2 - rectX - 1
                        local totalSize = this.endValue - this.startValue
                        local newValue = math.floor((newPos / (rectW - 3)) * (totalSize - this.size + this.startValue))
                        this._onValueChange(newValue - this.value)
                        return this
                    end
                end
            elseif event.name == "mouse_drag" then
                if event.param3 >= y and event.param3 < y + h and this.mode == 3 and ((this.pressedButton == 1 and event.param2 == x) or (this.pressedButton == 2 and event.param2 == x + w - 1)) then
                    this.mode = 4
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                    return this
                elseif this.mode == 4 then
                    if this.pressedButton == 0 then
                        local newPos = math.max(0, math.min(rectW - 2, event.param2 - rectX - 1))
                        local totalSize = this.endValue - this.startValue
                        local newValue = math.floor((newPos / (rectW - 3)) * (totalSize - this.size + this.startValue))
                        this._onValueChange(newValue - this.value)
                        return this
                    else
                        this.mode = 3
                        this.recalculate()
                        this.repaint("this", x, y, w, h)
                        return this
                    end
                end
            elseif event.name == "mouse_up" then
                if this.mode == 3 or this.mode == 4 then
                    this.mode = 1
                    this.recalculate()
                    this.repaint("this", x, y, w, h)
                    this.repeatItem.reset()
                    this.getManager().parallelManager.removeFunction(this._repeatButtonPressElement)
                    this.pressedButton = 0
                    return this
                end
            end
        end
    end
    return this
end
