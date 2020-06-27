extends Area2D

func _on_area_patient2_body_entered(body) -> void:
	if global.dungeon_keys == 0:
		match str(global.dungeon_current_stage):
			"0":
				global.player_appear_location = Vector2(176, 832)
				dialogue.dialogue_path = "res://dialogue/chapter2/lone-0-%s.json" % global.system_language
			"1", "2":
				dialogue.dialogue_path = "res://dialogue/chapter2/lone-nokey-%s.json" % global.system_language
			"3":
				dialogue.dialogue_path = "res://dialogue/chapter2/lone-3-%s.json" % global.system_language
	elif global.dungeon_keys != 0:
		global.player_appear_location = Vector2(176, 832)
		match str(global.dungeon_current_stage):
			"1":
				dialogue.dialogue_path = "res://dialogue/chapter2/lone-1-%s.json" % global.system_language
			"2":
				dialogue.dialogue_path = "res://dialogue/chapter2/lone-2-%s.json" % global.system_language 
	print(dialogue.dialogue_path)
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	dialogue.dialogue_transition = "res://maps/chapter2/chapter2-lone_dungeon.tscn"


func _on_area_patient2_body_exited(body):
	dialogue.dialogue_path = ""
	dialogue.dialogue_transition = ""
