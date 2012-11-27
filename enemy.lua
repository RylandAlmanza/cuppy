function create_enemy(x, y, number_of_characters, direction)
    -- Choose random enemy type
    local character = math.random(number_of_characters)

    -- Return enemy table
    return {
        x = x,
        y = y,
        character = character,
        direction = direction,
        target = nil,
        moving = true
    }
end
