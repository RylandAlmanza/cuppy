function load_world(map_table)
    -- The world is an array of areas, which each have a tileset and a group of
    -- nodes. Map files for Cuppy are exported from Tiled, with tilesets and
    -- node sets (actually object groups) in pairs. For example, the tileset and
    -- node group of the first area are the first and second layers of the map
    -- file respectively. The tileset and node group of the second area are the
    -- third and fourth layers. etc.
    local world = {}
    for i=1,#map_table.layers/2,1 do
        local area_tiles = map_table.layers[(i * 2) - 1].data
        local area_nodes = map_table.layers[i * 2].objects
        world[i] = {tiles = area_tiles, nodes = area_nodes}
    end
    return world
end
