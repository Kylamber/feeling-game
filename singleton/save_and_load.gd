extends Node

var path: String = "user://data.json"

# The default values
var default_data: Dictionary = {
			"player" : {
				"weapon" : "unarmed",
				"max_health" : 6
				},
			"level" : {
				"level_path" : "res://maps/chapter1/chapter1-1.tscn",
				"next_level_path": "res://maps/chapter1/chapter1-end.tscn",
				"posx" : -104,
				"posy" : 56,
				"current_stage" : 0,
				"keys" : 0
			},
			"settings" : {
				"language" : "indonesia"
			}
		}

var data: Dictionary = { }


func _ready() -> void:
	load_game()


func load_game() -> void:
	var file = File.new()
	if not file.file_exists(path):
		reset_data()
		return
	
	file.open(path, file.READ)
	var text = file.get_as_text()
	data = parse_json(text)
	file.close()
	
	# Transfer data to global_variable to avoid errors
	global.system_language = data["settings"]["language"]
	global.dungeon_current_stage = data["level"]["current_stage"]
	global.dungeon_keys = data["level"]["keys"]
	global.player_appear_location = Vector2(data["level"]["posx"], data["level"]["posy"])


func save_game() -> void:
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(data))
	file.close()


func new_game() -> void:
	reset_data()
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	load_game()


func reset_data() -> void:
	data = default_data.duplicate(true)


