extends Area2D

var _selected_dialogue: String


func _ready() -> void:
	_set_dialogue()


func _on_area_dialogue_mom_body_entered(body) -> void:
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	dialogue.dialogue_path = _selected_dialogue


func _on_area_dialogue_mom_body_exited(body) -> void:
	dialogue.dialogue_path = ""


func _set_dialogue() -> void:
	if global.dungeon_keys == 0:
		match str(global.dungeon_current_stage):
			"0":
				_selected_dialogue = "res://dialogue/chapter1/npc_mom-0-%s.json" % global.system_language
			"1":
				_selected_dialogue = "res://dialogue/chapter1/npc_mom-1-%s.json" % global.system_language
			"2":
				_selected_dialogue = "res://dialogue/chapter1/npc_mom-2-%s.json" % global.system_language
	elif global.dungeon_keys != 0:
		match str(global.dungeon_current_stage):
			"1":
				_selected_dialogue = "res://dialogue/chapter1/npc_mom-havekey-%s.json" % global.system_language
			"2":
				_selected_dialogue = "res://dialogue/chapter1/npc_mom-havekey2-%s.json" % global.system_language
