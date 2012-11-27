require("constants")
require("general-utils")
require("world")
require("player")
require("enemy")

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
    player = create_player(player_x, player_y, GUY)
    player.destination = world[1].nodes[2]
    -- Create enemy
    --enemy = create_enemy()
end

function love.update()
    -- If the player has not yet reached the current destination:
    if player.walking == true then
        -- Move the player towards the current destination
        player:walk()
        -- If the player has reached the current destination:
        if player:reached_destination() then
            if player.direction == RIGHT then
                if player.node + 1 < #world[player.position].nodes then
                    player.node = player.node + 1
                else
                    if player.position < #world then
                        player.position = player.position + 1
                        player.node = 1
                    else
                        player.node = player.node + 1
                    end
                    player.walking = false
                end
                if world[player.position].nodes[player.node].properties.fight ==
                   "left" then
                    player.walking = false
                else
                    player.destination = world[player.position].nodes[player.node + 1]
                end
            elseif player.direction == LEFT then
                if player.node - 1 > 1 then
                    player.node = player.node - 1
                else
                    if player.position - 1 > 0 then
                        player.position = player.position - 1
                        player.node = #world[player.position].nodes
                    else
                        player.node = player.node - 1
                    end
                    player.walking = false
                end
                if world[player.position].nodes[player.node].properties.fight ==
                   "right" then
                    player.walking = false
                else
                    player.destination = world[player.position].nodes[player.node - 1]
                end
            end
            player.x = world[player.position].nodes[player.node].x
            player.y = world[player.position].nodes[player.node].y
        end
    end
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
    --love.graphics.drawq(
    --    sprite_sheet,
    --    sprites[enemy.character][enemy.direction],
    --    enemy.x,
    --    enemy.y
    --)
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
