function create_player(x, y, character)
    -- Return player table
    return {
        x = x,
        y = y,
        position = 1,
        character = character,
        direction = RIGHT,
        node = 1,
        destination = nil,
        walking = false,
        walk = function(self)
            -- Move the player towards destination on the x-axis
            if self.x < self.destination.x then
                self.x = self.x + 4
            elseif self.x > self.destination.x then
                self.x = self.x - 4
            end
            -- Move the player towards destination on the y-axis
            if self.y < self.destination.y then
                self.y = self.y + 4
            elseif self.y > self.destination.y then
                self.y = self.y - 4
            end
        end,
        reached_destination = function(self)
            if self.x == self.destination.x and
               self.y == self.destination.y then
                return true
            else
                return false
            end
        end
    }
end
