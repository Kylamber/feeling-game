extends Control

export (String) var title
export (String) var subtitle
export (String) var path
export (Vector2) var loc

onready var _animation_end_title: AnimationPlayer = $anim_end_title
onready var _title: Label = $CenterContainer/VBoxContainer/label_title
onready var _subtitle: Label = $CenterContainer/VBoxContainer/label_subtitle


func _ready() -> void:
	pause.pausable = false
	_animation_end_title.play("fade")
	_set_text()
	yield($anim_end_title, "animation_finished")
	yield(get_tree().create_timer(1), "timeout")
	global.dungeon_current_stage = 0
	global.dungeon_keys = 0
	fade.transition(path, 0.5, loc)
	save_and_load.data["player"]["max_health"] += 2


func _set_text() -> void:
	_title.text = title
	_subtitle.text = subtitle
