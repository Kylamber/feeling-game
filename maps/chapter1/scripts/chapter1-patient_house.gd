extends Node2D

onready var _collision_area_change: CollisionShape2D = $tilemap_house_interior_decor/area_change_map/col_area_change

func _ready():
	audio.play("bgm_clockwork")
	if global.dungeon_current_stage == 3:
		_collision_area_change.disabled = true
