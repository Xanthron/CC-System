if turtle then
    local bedrock = "minecraft:bedrock"
    turtle.move = {}

    function turtle.move.dir(v, f)
        return vector.new(v.x * f.x + v.y * f.y, -v.x * f.y + v.y * f.x, v.z)
    end

    function turtle.move.look(dir, f, update)
        if dir == "forward" then
            if f.x < 0 then
                turtle.move.turnLeft(update)
                turtle.move.turnLeft(update)
            elseif f.y > 0 then
                turtle.move.turnLeft(update)
            elseif f.y < 0 then
                turtle.move.turnRight(update)
            end
        elseif dir == "back" then
            if f.x > 0 then
                turtle.move.turnLeft(update)
                turtle.move.turnLeft(update)
            elseif f.y > 0 then
                turtle.move.turnRight(update)
            elseif f.y < 0 then
                turtle.move.turnLeft(update)
            end
        elseif dir == "left" then
            if f.y > 0 then
                turtle.move.turnLeft(update)
                turtle.move.turnLeft(update)
            elseif f.x > 0 then
                turtle.move.turnLeft(update)
            elseif f.x < 0 then
                turtle.move.turnRight(update)
            end
        elseif dir == "right" then
            if f.y < 0 then
                turtle.move.turnLeft(update)
                turtle.move.turnLeft(update)
            elseif f.x > 0 then
                turtle.move.turnRight(update)
            elseif f.x < 0 then
                turtle.move.turnLeft(update)
            end
        end
    end

    ---@param update function
    function turtle.move.forward(update)
        if update then
            update(nil, nil, true)
        end
        local is, data = turtle.inspect()
        if is and data.name == bedrock then
            if update then
                update(nil, nil, false)
            end
            return false
        end
        while not turtle.forward() do
            turtle.dig()
            turtle.attack()
        end
        if update then
            update(nil, vector.forward, false)
        end
        return true
    end

    ---@param update function
    function turtle.move.up(update)
        if update then
            update(nil, nil, true)
        end
        local is, data = turtle.inspectUp()
        if is and data.name == bedrock then
            if update then
                update(nil, nil, false)
            end
            return false
        end
        while not turtle.up() do
            turtle.digUp()
            turtle.attackUp()
        end
        if update then
            update(nil, vector.up, false)
        end
        return true
    end

    ---@param update function
    function turtle.move.down(update)
        if update then
            update(nil, nil, true)
        end
        local is, data = turtle.inspectDown()
        if is and data.name == bedrock then
            if update then
                update(nil, nil, false)
            end
            return false
        end
        while not turtle.down() do
            turtle.digDown()
            turtle.attackDown()
        end
        if update then
            update(nil, vector.down, false)
        end
        return true
    end

    ---@param update function
    function turtle.move.turnLeft(update)
        if update then
            update(nil, nil, true)
        end
        turtle.turnLeft()
        if update then
            update(vector.new(1, -1, 0), nil, false)
        end
        return true
    end

    ---@param update function
    function turtle.move.turnRight(update)
        if update then
            update(nil, nil, true)
        end
        turtle.turnRight()
        if update then
            update(vector.new(-1, 1, 0), nil, false)
        end
        return true
    end

    ---@param update function
    function turtle.move.back(update)
        local ret = true
        if update then
            update(nil, nil, true)
        end
        if not turtle.back() then
            turtle.turnLeft(update)
            turtle.turnLeft(update)
            ret = turtle.move.forward(update)
            turtle.turnLeft(update)
            turtle.turnLeft(update)
        end
        if update then
            if ret then
                update(nil, vector.backward, false)
            else
                update(nil, nil, false)
            end
        end
    end

    ---@param v vector
    ---@param update function
    function turtle.move.go(v, update, f)
        if f then
            v = turtle.move.dir(v, f)
        end
        local turns = 0

        if v.z > 0 then
            for i = 1, v.z do
                if not turtle.move.up(update) then
                    if turtle.move.back(update) then
                        return turtle.move.go(vector.new(v.x, v.y, v.z - i + 1))
                    else
                        return false
                    end
                end
            end
        elseif v.z < 0 then
            for i = 1, -v.z do
                if not turtle.move.down(update) then
                    return false
                end
            end
        end

        if v.x > 0 then
            for i = 1, v.x do
                if not turtle.move.forward(update) then
                    return false
                end
            end
        end
        if v.y > 0 then
            turns = 1
            turtle.move.turnRight(update)
            for i = 1, v.y do
                if not turtle.move.forward(update) then
                    return false
                end
            end
        elseif v.y < 0 then
            turns = 2
            turtle.move.turnLeft(update)
            for i = 1, -v.y do
                if not turtle.move.forward(update) then
                    return false
                end
            end
        end
        if v.x < 0 then
            if turns == 0 then
                turtle.move.turnRight(update)
                turtle.move.turnRight(update)
            elseif turns == 1 then
                turtle.move.turnRight(update)
            elseif turns == 2 then
                turtle.move.turnLeft(update)
            end
            for i = 1, -v.x do
                if not turtle.move.forward(update) then
                    return false
                end
            end
        end
        return true
    end
end
