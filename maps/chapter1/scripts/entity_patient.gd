extends KinematicBody2D

var _selected_dialogue: String
var _selected_dialogue_transition: String


func _ready() -> void:
	_set_dialogue()


func _on_area_patient_dialogue_body_entered(body) -> void:
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	dialogue.dialogue_path = _selected_dialogue
	dialogue.dialogue_transition = _selected_dialogue_transition


func _on_area_patient_dialogue_body_exited(body) -> void:
	dialogue.dialogue_path = ""
	dialogue.dialogue_transition = ""


func _set_dialogue() -> void:
	if global.dungeon_current_stage == 0: # Starting out
		_selected_dialogue = "res://dialogue/chapter1/anger-0-%s.json" % global.system_language
		_selected_dialogue_transition = "res://maps/chapter1/chapter1-feeling_dungeon.tscn"
		global.player_appear_location = Vector2(160, 912)
	
	elif global.dungeon_keys != 0 and global.dungeon_current_stage != 0: # Has key, and continue
		match str(global.dungeon_current_stage):
			"1":
				_selected_dialogue = "res://dialogue/chapter1/anger-1-%s.json" % global.system_language
			"2":
				_selected_dialogue = "res://dialogue/chapter1/anger-2-%s.json" % global.system_language
		
		_selected_dialogue_transition = "res://maps/chapter1/chapter1-feeling_dungeon.tscn"
		global.player_appear_location = Vector2(160, 912)
	
	elif global.dungeon_keys == 0 and global.dungeon_current_stage == 3:
		_selected_dialogue = "res://dialogue/chapter1/anger-3-%s.json" % global.system_language
	
	elif global.dungeon_keys == 0 and global.dungeon_current_stage != 0: # No key, and already completed first stage
		_selected_dialogue = "res://dialogue/chapter1/anger-nokey-%s.json" % global.system_language
