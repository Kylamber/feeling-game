extends StaticBody2D

# Nodes
onready var _particle_campfire: Particles2D = $particle_campfire
onready var _sfx_firepoof: AudioStreamPlayer2D = $sfx_firepoof
onready var _light_campfire: Light2D = $light_campfire

var enabled: bool = false
export (String) var level_path: String = ""
export (String) var next_level_path: String = ""


func _on_area_detect_player_body_entered(body) -> void:
	if enabled == false:
		enabled = true
		tooltips.show_tooltips("tooltips", "Checkpoint")
		_light_campfire.show()
		_sfx_firepoof.play()
		_particle_campfire.emitting = true
		_save_data()


func _save_data() -> void:
	save_and_load.data["level"]["next_level_path"] = next_level_path
	save_and_load.data["level"]["level_path"] = level_path
	save_and_load.data["level"]["posx"] = position.x + 10
	save_and_load.data["level"]["posy"] = position.y
	save_and_load.save_game()
