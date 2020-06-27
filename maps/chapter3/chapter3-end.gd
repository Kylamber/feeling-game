extends Control

onready var _animation_end_title: AnimationPlayer = $anim_end_title


func _ready() -> void:
	pause.pausable = false
	_animation_end_title.play("fade")
	yield($anim_end_title, "animation_finished")
	yield(get_tree().create_timer(1), "timeout")
	global.dungeon_current_stage = 0
	global.dungeon_keys = 0
	fade.transition("res://ui/start_menu.tscn")


