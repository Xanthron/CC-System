function new(startRepeatSpeed, endRepeatSpeed, repeatSpeedIncrement)
    --- A simple class to handle repeating in a set time. Capable of changing the repeat speed over time
    ---@class repeatItem
    local this = {
        _lastPressTime = -1,
        _currentRepeatSpeed = startRepeatSpeed,
        startRepeatSpeed = startRepeatSpeed,
        endRepeatSpeed = endRepeatSpeed,
        repeatSpeedIncrement = repeatSpeedIncrement
    }

    this.reset = function()
        this._lastPressTime = -1
        this._currentRepeatSpeed = this.startRepeatSpeed
    end

    this.call = function()
        if this._lastPressTime == -1 then
            this._lastPressTime = os.clock()
        else
            if os.clock() - this._lastPressTime > this._currentRepeatSpeed then
                this._currentRepeatSpeed = math.max(this._currentRepeatSpeed * this.repeatSpeedIncrement, this.endRepeatSpeed)
                this._lastPressTime = os.clock()
            else
                return false
            end
        end
        return true
    end

    return this
end
