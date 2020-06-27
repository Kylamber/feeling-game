extends Area2D


func _on_area_dialogue_citizen_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	if global.dungeon_keys == 0 and global.dungeon_current_stage == 0:
		dialogue.dialogue_path = "res://dialogue/chapter2/npc_citizen-nokey-0-%s.json" % global.system_language
	else:
		dialogue.dialogue_path = "res://dialogue/chapter2/npc_citizen-default-%s.json" % global.system_language


func _on_area_dialogue_citizen_body_exited(body):
	dialogue.dialogue_path = ""
