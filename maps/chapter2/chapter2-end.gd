extends Control

onready var _anim_end: AnimationPlayer = $anim_end


func _ready():
	pause.pausable = false
	_anim_end.play("fade")
	yield(_anim_end, "animation_finished")
	yield(get_tree().create_timer(1), "timeout")
	global.dungeon_current_stage = 0
	global.dungeon_keys = 0
	fade.transition("res://maps/chapter3/chapter3-1.tscn", 0.5, Vector2(72, 56))

