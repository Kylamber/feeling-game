extends Node2D

onready var _col_change_map: CollisionShape2D = $area_change_map/col_change_map


func _ready() -> void:
	audio.play("bgm_tundra")
	if global.dungeon_current_stage == 3:
		_col_change_map.disabled = true

