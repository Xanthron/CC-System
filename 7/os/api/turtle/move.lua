if turtle then
    turtle.move = {}

    ---@param facing vector
    ---@param position vector
    ---@param update function
    function turtle.move.forward(facing, position, update)
        while not turtle.forward() do
            turtle.dig()
        end
        if position then
            position:set(position.x + 1 * facing.x, position.y + 1 * facing.y)
            if update then
                update()
            end
        end
    end

    ---@param position vector
    ---@param update function
    function turtle.move.up(position, update)
        while not turtle.up() do
            turtle.digUp()
        end
        if position then
            position:set(nil, nil, position.z + 1)
            if update then
                update()
            end
        end
    end

    ---@param position vector
    ---@param update function
    function turtle.move.down(position, update)
        while not turtle.down() do
            turtle.digDown()
        end
        if position then
            position:set(nil, nil, position.z - 1)
            if update then
                update()
            end
        end
    end

    ---@param facing vector
    ---@param update function
    function turtle.move.turnLeft(facing, update)
        turtle.turnLeft()
        if facing then
            facing:set(facing.y, -facing.x)
            if update then
                update()
            end
        end
    end

    ---@param facing vector
    ---@param update function
    function turtle.move.turnRight(facing, update)
        turtle.turnRight()
        if facing then
            facing:set(-facing.y, facing.x)
            if update then
                update()
            end
        end
    end

    ---@param facing vector
    ---@param position vector
    ---@param update function
    function turtle.move.back(facing, position, update)
        while not turtle.back() do
            turtle.turnLeft(facing, update)
            turtle.turnLeft(facing, update)
            turtle.dig()
            turtle.turnLeft(facing, update)
            turtle.turnLeft(facing, update)
        end
        if position then
            position:set(position.x - 1 * facing.x, position.y - 1 * facing.y)
            if update then
                update(facing, position)
            end
        end
    end

    ---@param v vector
    ---@param facing vector
    ---@param position vector
    ---@param update function
    function turtle.move.go(v, facing, position, update)
        local forward = v.x * facing.x + v.y * facing.y
        local right = v.y * facing.x + v.x * -facing.y
        local up = v.z

        local turns = 0

        if up > 0 then
            for i = 1, up do
                turtle.move.up(position, update)
            end
        elseif up < 0 then
            for i = 1, -up do
                turtle.move.down(position, update)
            end
        end

        if forward > 0 then
            for i = 1, forward do
                turtle.move.forward(facing, position, update)
            end
        end
        if right > 0 then
            turns = 1
            turtle.move.turnRight(facing, update)
            for i = 1, right do
                turtle.move.forward(facing, position, update)
            end
        elseif right < 0 then
            turns = 2
            turtle.move.turnLeft(facing, update)
            for i = 1, -right do
                turtle.move.forward(facing, position, update)
            end
        end

        if forward < 0 then
            if turns == 0 then
                turtle.move.turnRight(facing, update)
                turtle.move.turnRight(facing, update)
            elseif turns == 1 then
                turtle.move.turnRight(facing, update)
            elseif turns == 2 then
                turtle.move.turnLeft(facing, update)
            end
            for i = 1, -forward do
                turtle.move.forward(facing, position, update)
            end
        end
    end
end
