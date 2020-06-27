extends Area2D


func _ready():
	if global.dungeon_current_stage >= 1:
		position = Vector2(40, 96)


func _on_area_patient3_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	match str(global.dungeon_current_stage):
		"0":
			dialogue.dialogue_path = "res://dialogue/chapter3/nycto-0-%s.json" % global.system_language
		"1":
			dialogue.dialogue_path = "res://dialogue/chapter3/nycto-1-%s.json" % global.system_language
		"2":
			dialogue.dialogue_path = "res://dialogue/chapter3/nycto-2-%s.json" % global.system_language
	dialogue.dialogue_transition = "res://maps/chapter3/chapter3-nycto_dungeon.tscn"
	global.player_appear_location = Vector2(160, 528)


func _on_area_patient3_body_exited(body):
	dialogue.dialogue_path = ""
	dialogue.dialogue_transition = ""
