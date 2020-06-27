extends TileMap

func _ready():
	global.tile_used_rect = get_used_rect() 
	global.tile_cell_size = cell_size

