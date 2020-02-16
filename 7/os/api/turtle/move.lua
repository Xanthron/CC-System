if turtle then
    turtle.move = {}

    ---@param update function
    function turtle.move.forward(update)
        update(nil, nil, true)
        while not turtle.forward() do
            turtle.dig()
        end
        if update then
            update(nil, vector.forward, false)
        end
    end

    ---@param update function
    function turtle.move.up(update)
        update(nil, nil, true)
        while not turtle.up() do
            turtle.digUp()
        end
        if update then
            update(nil, vector.up, false)
        end
    end

    ---@param update function
    function turtle.move.down(update)
        update(nil, nil, true)
        while not turtle.down() do
            turtle.digDown()
        end
        if update then
            update(nil, vector.down, false)
        end
    end

    ---@param update function
    function turtle.move.turnLeft(update)
        update(nil, nil, true)
        turtle.turnLeft()
        if update then
            update(vector.new(1, -1, 0), nil, false)
        end
    end

    ---@param update function
    function turtle.move.turnRight(update)
        update(nil, nil, true)
        turtle.turnRight()
        if update then
            update(vector.new(-1, 1, 0), nil, false)
        end
    end

    ---@param update function
    function turtle.move.back(update)
        update(nil, nil, true)
        while not turtle.back() do
            turtle.turnLeft(update)
            turtle.turnLeft(update)
            turtle.dig()
            turtle.turnLeft(update)
            turtle.turnLeft(update)
        end
        if update then
            update(nil, vector.backward, false)
        end
    end

    ---@param v vector
    ---@param update function
    function turtle.move.go(v, update)
        local turns = 0

        if v.z > 0 then
            for i = 1, v.z do
                turtle.move.up(update)
            end
        elseif v.z < 0 then
            for i = 1, -v.z do
                turtle.move.down(update)
            end
        end

        if v.x > 0 then
            for i = 1, v.x do
                turtle.move.forward(update)
            end
        end
        if v.y > 0 then
            turns = 1
            turtle.move.turnRight(update)
            for i = 1, v.y do
                turtle.move.forward(update)
            end
        elseif v.y < 0 then
            turns = 2
            turtle.move.turnLeft(update)
            for i = 1, -v.y do
                turtle.move.forward(update)
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
                turtle.move.forward(update)
            end
        end
    end
end
