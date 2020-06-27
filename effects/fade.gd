extends CanvasLayer

onready var _animation_fade: AnimationPlayer = $fade_tr

func transition(path: String = "", delay: float = 0.5, location: Vector2 = Vector2(0,0)) -> void:
	var file = File.new()
	if file.file_exists(path):
		yield(get_tree().create_timer(delay), "timeout")
		_animation_fade.play("fade")
		yield(_animation_fade, "animation_finished")
		get_tree().change_scene(path)
		global.player_appear_location = location
		_animation_fade.play_backwards("fade")
	
	elif !file.file_exists(path):
		#warning
		print("WARNING : File path doesn't exist (TRANSITION)")
		print("WARNING_PATH : %s" % path)
