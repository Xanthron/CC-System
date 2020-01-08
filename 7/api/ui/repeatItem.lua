---@return repeatItem
function new(startRepeatSpeed, endRepeatSpeed, repeatSpeedIncrement)
    ---Class to handle input that happens every frames but should get executed at fix times
    ---@class repeatItem
    local this = {
        _lastPressTime = -1,
        _currentRepeatSpeed = startRepeatSpeed,
        startRepeatSpeed = startRepeatSpeed,
        endRepeatSpeed = endRepeatSpeed,
        repeatSpeedIncrement = repeatSpeedIncrement
    }
    ---Reset the data
    ---@return nil
    function this:reset()
        self._lastPressTime = -1
        self._currentRepeatSpeed = self.startRepeatSpeed
    end
    ---Get the execution state
    ---@return boolean
    function this:call()
        if self._lastPressTime == -1 then
            self._lastPressTime = os.clock()
        else
            if os.clock() - self._lastPressTime > self._currentRepeatSpeed then
                self._currentRepeatSpeed =
                    math.max(self._currentRepeatSpeed * self.repeatSpeedIncrement, self.endRepeatSpeed)
                self._lastPressTime = os.clock()
            else
                return false
            end
        end
        return true
    end
    return this
end
