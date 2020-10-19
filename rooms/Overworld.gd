extends Node2D

const Wall = preload("res://objects/specials/Wall.tscn")

#
# Two-dimensional array where each first-layer element is a tile in the tilemap, and each
# second-layer element is a coordinate on the related tile's atlas of a subtile that should be a
# wall.
#
const WallTiles = [ 
	[
		Vector2(3, 4),  # Pine Tree
		Vector2(5, 4),  # Stump
		Vector2(6, 4),  # Dead Tree
		Vector2(14, 4), # Cattails
		Vector2(0, 3),  # Stone Wall
		Vector2(1, 3),
		Vector2(2, 3),
		Vector2(3, 3),
		Vector2(4, 3),
		Vector2(5, 3),  # Brick Wall
		Vector2(6, 3),
		Vector2(7, 3),
		Vector2(8, 3),
		Vector2(9, 3),
		Vector2(10, 3),
		Vector2(11, 3),
		Vector2(12, 3),  # Wood Wall
		Vector2(13, 3),
		Vector2(14, 3),
		Vector2(15, 3),
		Vector2(16, 3),  # Fence
		Vector2(17, 3),
		Vector2(18, 3),
		Vector2(4, 1),   # Door
		Vector2(0, 9),   # Crop
		Vector2(19, 13), # Boat
		Vector2(10, 14), # Water
		Vector2(11, 14),
		Vector2(12, 14),
		Vector2(13, 14),
		Vector2(14, 14),
		Vector2(15, 14),
		Vector2(16, 14),
		Vector2(17, 14),
		Vector2(18, 14),
		Vector2(19, 14),
		Vector2(0, 16),  # Furniture
		Vector2(1, 16),
		Vector2(2, 16),
		Vector2(3, 16),
		Vector2(4, 16),
		Vector2(5, 16),
		Vector2(6, 16),
		Vector2(7, 16),
		Vector2(8, 16),
		Vector2(9, 16),
		Vector2(10, 16),
		Vector2(11, 16),
		Vector2(12, 16),
		Vector2(13, 16),
		Vector2(14, 16),
		Vector2(15, 16),
		Vector2(16, 16),
		Vector2(17, 16),
		Vector2(18, 16),
		Vector2(19, 16),
		Vector2(0, 17),  # More Furniture
		Vector2(1, 17),
		Vector2(2, 17),
		Vector2(3, 17),
		Vector2(4, 17),
		Vector2(5, 17),
		Vector2(6, 17),
		Vector2(7, 17),
		Vector2(8, 17),
		Vector2(9, 17),
		Vector2(10, 17),
		Vector2(11, 17),
		Vector2(12, 17),
		Vector2(13, 17),
		Vector2(14, 17),
		Vector2(15, 17),
		Vector2(16, 17),
		Vector2(17, 17),
		Vector2(18, 17),
		Vector2(19, 17),
		Vector2(17, 18), # Tomb Stones
		Vector2(18, 18),
		Vector2(6, 18),  # Bones
		Vector2(7, 18),
		Vector2(8, 18),
		Vector2(9, 18),
		Vector2(6, 10),  # Fire Pit
		Vector2(10, 6),  # Pumpkin
	],
	[
		Vector2(19, 4), # Candle
		Vector2(17, 9), # Skull on Stick
		Vector2(3, 9),  # Culdron
	]
]

func _ready():
	#
	# For debug purposes, print out the tile index of the tile at the (0, 0) cell of the tilemap.
	#
	var debug_tile_id = $TileMap.get_cell(0, 0)
	var debug_atlas_pos = $TileMap.get_cell_autotile_coord(0, 0)
	var debug_real_pos = $TileMap.map_to_world(Vector2(0, 0))
	
	print("TileMap (0, 0) Cell = (cellId: %s, atlasPos: %s, realPos: %s)" % [String(debug_tile_id), String(debug_atlas_pos), String(debug_real_pos)])
	
	#
	# Create walls everywhere that a collidable tile exists in the tilemap.
	#
	for cell_pos in $TileMap.get_used_cells():
		var tile_id = $TileMap.get_cellv(cell_pos)
		var atlas_pos = $TileMap.get_cell_autotile_coord(cell_pos.x, cell_pos.y)
		
		if atlas_pos in WallTiles[tile_id]:
			var wall = Wall.instance()
			var wall_pos = $TileMap.map_to_world(cell_pos)
			
			wall.set_position(wall_pos)
			
			$TileMap.add_child(wall)
