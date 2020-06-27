extends CanvasLayer


onready var _master_node: Control = $control_dialogue
onready var _label_dialogue:  Label = $control_dialogue/dialogue_container/dialogue_texture/dialogue_text
onready var _texrect_dialogue: TextureRect = $control_dialogue/dialogue_container/dialogue_texture/dialogue_sprite
onready var _animation_dialogue: AnimationPlayer = $dialogue_animation
onready var _sfx_dialogue := $audio_dialogue

var dialogue: Dictionary = { }
var current_dialogue: int = 1
var dialogue_transition: String = ""
var dialogue_path: String = ""
var dialogue_available: bool = false


func _ready():
	_master_node.hide()


func _load_dialogue(path) -> Dictionary:
	var file = File.new()
	if !file.file_exists(path):
		# Debug
		print("WARNING : File path not found (DIALOGUE)")
		pass

	file.open(path, file.READ)
	var dialogue_parsed = JSON.parse(file.get_as_text()).result
	if not dialogue_parsed.size() > 0:
		# Debug
		print("WARNING : Empty dialogue (DIALOGUE)")
		pass
	
	return dialogue_parsed


func start_dialogue() -> void:
	_master_node.show()
	_animation_dialogue.seek(0, true)
	dialogue = _load_dialogue(dialogue_path)
	global.player.state = "dialogue"
	_update_dialogue()


func _update_dialogue() -> void:
	_sfx_dialogue.play()
	_label_dialogue.text = (dialogue[str(current_dialogue)]["text"])
	_texrect_dialogue.texture = load(dialogue[str(current_dialogue)]["image_path"])
	_animation_dialogue.play("dialogue_text_show")
	yield(_animation_dialogue, "animation_finished")


func _stop_dialogue() -> void:
	_animation_dialogue.seek(0, true)
	_master_node.hide()
	_dialogue_command()
	global.player.state = "dialogue_finished"
	dialogue_path = ""
	current_dialogue = 1


func _dialogue_command() -> void:
	if dialogue[str(current_dialogue - 1)]["command"] != "":
		match dialogue[str(current_dialogue - 1)]["command"]:
			"give_key":
				global.dungeon_keys += 1
				tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["key_found"])
			"transition":
				fade.transition(dialogue_transition, 0.5, global.player_appear_location)
			"next_level":
				fade.transition(save_and_load.data["level"]["next_level_path"])


func next_dialogue() -> void:
	current_dialogue += 1
	_animation_dialogue.seek(0, true)
	if current_dialogue <= dialogue.values().size():
		_update_dialogue()
	else:
		_stop_dialogue()
