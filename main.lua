function render_area()
    -- If the current area is a battle area, render the battle area map.
    -- Currently there is only one battle area map, but eventually every battle
    -- area will be unique
    if world[player.position] == BATTLE then
        for y=1,8,1 do
            for x=1,8,1 do
                local tile = map.layers[1].data[((y-1)*8)+x]
                if tile > 0 then
                    love.graphics.drawq(
                        tile_sheet,
                        tiles[map.layers[1].data[((y-1)*8)+x]],
                        (x - 1) * 32,
                        (y - 1) * 32
                    )
                end
            end
        end
    -- If the current area is a town, create plain, flat ground.
    elseif world[player.position] == TOWN then
        for y=1,8,1 do
            for x=1,8,1 do
                if y == 8 then
                    love.graphics.drawq(
                        tile_sheet,
                        tiles[2],
                        (x - 1) * 32,
                        (y - 1) * 32
                    )
                end
            end
        end
    end
end

function create_enemy()
    -- Choose random enemy type
    local character = math.random(#sprites)
    -- Direction should be the opposite of the player's direction
    local direction = LEFT
    if player.direction == RIGHT then
        direction = LEFT
    elseif player.direction == LEFT then
        direction = RIGHT
    end

    enemy = {
        character = character,
        position = player.position,
        direction = direction
    }
end

function love.load()
    -- General constants
    GAME_WIDTH = 256
    GAME_HEIGHT = 256
    SPRITE_SIZE = 32

    -- Resize window
    love.graphics.setMode(GAME_WIDTH, GAME_HEIGHT)

    -- Load map
    map = require("map")

    -- Declare sprite quads
    RIGHT = 1
    LEFT = 2
    GUY = 1
    SKELETON = 2
    FISH = 3
    sprite_sheet = love.graphics.newImage("sprites-scaled.png")
    sprites = {}
    -- Guy sprites
    sprites[GUY] = {}
    sprites[GUY][RIGHT] = love.graphics.newQuad( 0, 0, 32, 32, 68, 104 )
    sprites[GUY][LEFT] = love.graphics.newQuad( 35, 0, 32, 32, 68, 104 )
    -- Skeleton sprites
    sprites[SKELETON] = {}
    sprites[SKELETON][RIGHT] = love.graphics.newQuad( 0, 35, 32, 32, 68, 104 )
    sprites[SKELETON][LEFT] = love.graphics.newQuad( 35, 35, 32, 32, 68, 104 )
    -- Fish sprites
    sprites[FISH] = {}
    sprites[FISH][RIGHT] = love.graphics.newQuad( 0, 70, 32, 32, 68, 104 )
    sprites[FISH][LEFT] = love.graphics.newQuad( 35, 70, 32, 32, 68, 104 )

    -- Store tile quads in an array
    tile_sheet = love.graphics.newImage(map.tilesets[1].image)
    tiles = {}
    for y=1,3,1 do
        for x=1,2,1 do
            table.insert(
                tiles,
                love.graphics.newQuad(
                    ((x - 1) * 32) + (4 * (x-1)),
                    ((y - 1) * 32) + (4 * (y-1)),
                    32,
                    32,
                    68,
                    104
                )
            )
        end
    end

    -- Create world
    BATTLE = 0
    TOWN = 1
    world = {TOWN, BATTLE, BATTLE, BATTLE, TOWN, BATTLE, BATTLE, TOWN}

    -- Create player
    player = { character = GUY, position = 1, direction = RIGHT}
    create_enemy()
end

function love.draw()
    -- Clear screen
    love.graphics.clear()
    -- Render current area map
    render_area()

    -- If the player is facing right (meaning the player came from the left,)
    -- place the player on the left side of the area map. Otherwise, place the
    -- player on the right side.
    local player_x = 0
    local enemy_x = 0
    if player.direction == RIGHT then
        player_x = 64
        enemy_x = 160
    elseif player.direction == LEFT then
        player_x = 160
        enemy_x = 64
    end

    -- Draw player
    love.graphics.drawq(
        sprite_sheet,
        sprites[player.character][player.direction],
        player_x,
        192
    )
    -- Draw enemy
    love.graphics.drawq(
        sprite_sheet,
        sprites[enemy.character][enemy.direction],
        enemy_x,
        192
    )
end

function love.keypressed(key)
    -- If the right arrow key is pressed, change the player's direction to
    -- right, and move the player to the next area. Then, create a new enemy.
    if (key == "right") then
        if player.position < #world then
            player.direction = RIGHT
            player.position = player.position + 1
            create_enemy()
        end
    -- If the left arrow key is pressed, change the player's direction to left,
    -- and move the player to the next area. Then, create a new enemy.
    elseif (key == "left") then
        if player.position > 1 then
            player.direction = LEFT
            player.position = player.position - 1
            create_enemy()
        end
    end
end
