require("constants")
require("general-utils")
require("world")
require("opponent")

function random_enemy()
    local enemy_character = math.random(#sprites)
    local enemy_node = 0
    if player.node == 1 then
        enemy_node = #world[player.position].nodes
    else
        enemy_node = 1
    end
    local enemy_x = world[player.position].nodes[enemy_node].x
    local enemy_y = world[player.position].nodes[enemy_node].y
    local enemy = create_opponent(enemy_x, enemy_y, enemy_character)
    enemy.direction = opposite_direction(player.direction)
    local enemy_destination = {}
    if enemy.direction == RIGHT then
        enemy_destination = world[player.position].nodes[enemy_node + 1]
    else
        enemy_destination = world[player.position].nodes[enemy_node - 1]
    end
    enemy.position = player.position
    enemy.node = enemy_node
    enemy.destination = enemy_destination

    return enemy
end
    

function love.load()
    -- Resize window
    love.graphics.setMode(GAME_WIDTH, GAME_HEIGHT)

    -- Load map
    map = require("map")

    -- Declare sprite quads
    sprite_sheet = love.graphics.newImage("sprites-scaled.png")
    sprites = {}
    -- Guy sprites
    sprites[GUY] = {}
    sprites[GUY][RIGHT] = love.graphics.newQuad( 0, 0, SPRITE_WIDTH, SPRITE_HEIGHT, 68, 104 )
    sprites[GUY][LEFT] = love.graphics.newQuad( 35, 0, SPRITE_WIDTH, SPRITE_HEIGHT, 68, 104 )
    -- Skeleton sprites
    sprites[SKELETON] = {}
    sprites[SKELETON][RIGHT] = love.graphics.newQuad( 0, 35, SPRITE_WIDTH, SPRITE_HEIGHT, 68, 104 )
    sprites[SKELETON][LEFT] = love.graphics.newQuad( 35, 35, SPRITE_WIDTH, SPRITE_HEIGHT, 68, 104 )
    -- Fish sprites
    sprites[FISH] = {}
    sprites[FISH][RIGHT] = love.graphics.newQuad( 0, 70, SPRITE_WIDTH, SPRITE_HEIGHT, 68, 104 )
    sprites[FISH][LEFT] = love.graphics.newQuad( 35, 70, SPRITE_WIDTH, SPRITE_HEIGHT, 68, 104 )

    -- Store tile quads in an array
    tile_sheet = love.graphics.newImage(map.tilesets[1].image)
    tiles = {}
    for y=1,6,1 do
        for x=1,2,1 do
            table.insert(
                tiles,
                love.graphics.newQuad(
                    ((x - 1) * SPRITE_WIDTH) + (4 * (x-1)),
                    ((y - 1) * SPRITE_HEIGHT) + (4 * (y-1)),
                    SPRITE_WIDTH,
                    SPRITE_HEIGHT,
                    68,
                    212
                )
            )
        end
    end

    -- Load world
    world = load_world(require("map"))

    -- Create player
    local player_x = world[1].nodes[1].x
    local player_y = world[1].nodes[1].y
    player = create_opponent(player_x, player_y, GUY)
    player.destination = world[1].nodes[2]
    -- Create enemy
    enemy = random_enemy()
end

function update_opponent(opponent)
    -- If the opponent has not yet reached the current destination:
    if opponent.walking == true then
        -- Move the opponent towards the current destination
        opponent:walk()
        -- If the opponent has reached the current destination:
        if opponent:reached_destination() then
            if opponent.direction == RIGHT then
                -- If the opponent is not at the end of the area:
                if opponent.node + 1 < #world[opponent.position].nodes then
                    opponent.node = opponent.node + 1
                -- If the opponent is at the end of the area:
                else
                    -- If the opponent is not in the last area of the world:
                    if opponent.position < #world then
                        opponent.position = opponent.position + 1
                        opponent.node = 1
                        enemy = random_enemy()
                    -- If the opponent is in the last area of thw world:
                    else
                        opponent.node = opponent.node + 1
                        opponent.walking = false
                    end
                    --opponent.walking = false
                end
                -- If the opponent coming from the left side is supposed to stop
                -- and fight here, stop the opponent to fight.
                if world[opponent.position].nodes[opponent.node].properties.fight ==
                   "left" then
                    opponent.walking = false
                -- If the opponent coming from the left side is not supposed to
                -- stop and fight here, continue.
                else
                    opponent.destination = world[opponent.position].nodes[opponent.node + 1]
                end
            elseif opponent.direction == LEFT then
                -- If the opponent is not at the beginning of the area:
                if opponent.node - 1 > 1 then
                    opponent.node = opponent.node - 1
                -- If the opponent is at the end of the area:
                else
                    -- If the opponent is not in the first area of the world:
                    if opponent.position - 1 > 0 then
                        opponent.position = opponent.position - 1
                        opponent.node = #world[opponent.position].nodes
                        enemy = random_enemy()
                    -- If the opponent is in the first area of thw world:
                    else
                        opponent.node = opponent.node - 1
                        opponent.walking = false
                    end
                    --opponent.walking = false
                end
                -- If the opponent coming from the right side is supposed to stop
                -- and fight here, stop the opponent to fight.
                if world[opponent.position].nodes[opponent.node].properties.fight ==
                   "right" then
                    opponent.walking = false
                -- If the opponent coming from the right side is not supposed to
                -- stop and fight here, continue.
                else
                    opponent.destination = world[opponent.position].nodes[opponent.node - 1]
                end
            end
            opponent.x = world[opponent.position].nodes[opponent.node].x
            opponent.y = world[opponent.position].nodes[opponent.node].y
        end
    end
end

function love.update()
    update_opponent(player)
    update_opponent(enemy)
end

function love.draw()
    -- Clear screen
    love.graphics.clear()
    -- Render current area map
    for y=1,8,1 do
        for x=1,8,1 do
            local tile = world[player.position].tiles[((y-1)*8)+x]
            if tile > 0 then
                love.graphics.drawq(
                    tile_sheet,
                    tiles[tile],
                    (x - 1) * SPRITE_WIDTH,
                    (y - 1) * SPRITE_HEIGHT
                )
            end
        end
    end

    -- Draw player
    love.graphics.drawq(
        sprite_sheet,
        sprites[player.character][player.direction],
        player.x,
        player.y
    )
    -- Draw enemy
    love.graphics.drawq(
        sprite_sheet,
        sprites[enemy.character][enemy.direction],
        enemy.x,
        enemy.y
    )
end

function love.keypressed(key)
    if player.walking == false then
        -- If the right arrow key is pressed, change the player's direction to
        -- right, and move the player to the next area. Then, create a new enemy.
        if key == "right" then
            player.direction = RIGHT
            if player.node < #world[player.position].nodes or
               player.position < #world then
                player.destination = world[player.position].nodes[player.node + 1]
                player.walking = true
            end
        end
        -- If the left arrow key is pressed, change the player's direction to left,
        -- and move the player to the next area. Then, create a new enemy.
        if key == "left" then
            player.direction = LEFT
            if player.node > 1 or
               player.position > 1 then
                player.destination = world[player.position].nodes[player.node - 1]
                player.walking = true
            end
        end
    end
end
