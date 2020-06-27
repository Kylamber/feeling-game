extends Area2D


func _on_area_dialogue_friend_body_entered(body) -> void:
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	if global.dungeon_keys == 0:
		match str(global.dungeon_current_stage):
			"0":
				dialogue.dialogue_path = "res://dialogue/chapter2/npc_friend-nokey-0-%s.json" % global.system_language
			"1":
				dialogue.dialogue_path = "res://dialogue/chapter2/npc_friend-nokey-1-%s.json" % global.system_language
			"2":
				dialogue.dialogue_path = "res://dialogue/chapter2/npc_friend-default-%s.json" % global.system_language
	elif global.dungeon_keys != 0:
		match str(global.dungeon_current_stage):
			"1":
				dialogue.dialogue_path = "res://dialogue/chapter2/npc_friend-haskey-1-%s.json" % global.system_language
			"2":
				dialogue.dialogue_path = "res://dialogue/chapter2/npc_friend-default-%s.json" % global.system_language 


func _on_area_dialogue_friend_body_exited(body):
	dialogue.dialogue_path = ""
