return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 8,
  height = 8,
  tilewidth = 32,
  tileheight = 32,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 4,
      margin = 0,
      image = "tiles-scaled.png",
      imagewidth = 68,
      imageheight = 212,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        3, 0, 0, 0, 0, 0, 3, 4,
        2, 2, 2, 7, 7, 2, 2, 2
      }
    },
    {
      type = "objectgroup",
      name = "Object Layer 1",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "1",
          type = "node",
          shape = "rectangle",
          x = 0,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "2",
          type = "node",
          shape = "rectangle",
          x = 64,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["fight"] = "left"
          }
        },
        {
          name = "3",
          type = "node",
          shape = "rectangle",
          x = 160,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["fight"] = "right"
          }
        },
        {
          name = "4",
          type = "node",
          shape = "rectangle",
          x = 224,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      name = "Tile Layer 2",
      x = 0,
      y = 0,
      width = 8,
      height = 8,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 12, 0, 0, 0, 0, 0, 0,
        0, 11, 2, 2, 2, 2, 2, 2,
        0, 11, 0, 0, 0, 0, 0, 0,
        0, 11, 0, 0, 0, 0, 0, 0,
        0, 11, 0, 0, 0, 0, 0, 0,
        0, 11, 0, 0, 0, 0, 0, 0,
        2, 2, 8, 8, 8, 8, 8, 8
      }
    },
    {
      type = "objectgroup",
      name = "Object Layer 2",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "1",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "2",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "3",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 32,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "4",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 32,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["fight"] = "left"
          }
        },
        {
          name = "5",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 32,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["fight"] = "right"
          }
        },
        {
          name = "6",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 32,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
