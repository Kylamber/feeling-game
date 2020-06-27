extends CanvasLayer

var pausable: bool

onready var _master_node: Control = $control_pause


func _ready():
	_master_node.hide()


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		pause()


func pause():
	if(pausable == true):
		get_tree().paused = not get_tree().paused
		if(get_tree().paused == true):
			_master_node.show()
		else:
			_master_node.hide()


func _on_btn_continue_pressed():
	pause()


func _on_btn_exit_pressed():
	pause()
	# Saving data
	save_and_load.data["level"]["current_stage"] = global.dungeon_current_stage
	save_and_load.data["player"]["weapon"] = global.player.weapon
	save_and_load.data["level"]["keys"] = global.dungeon_keys
	save_and_load.save_game()
	fade.transition("res://ui/start_menu.tscn")


func _on_btn_settings_pressed():
	var settings = load("res://ui/ui_settings.tscn").instance()
	add_child(settings)
