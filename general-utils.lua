function opposite_direction(direction)
    if direction == RIGHT then
        return LEFT
    elseif direction == LEFT then
        return RIGHT
    else
        return nil
    end
end
