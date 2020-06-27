extends Area2D

 
func _ready():
	pass # Replace with function body.


func _on_area_mom_dialogue_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	if global.dungeon_keys == 0:
		match str(global.dungeon_current_stage):
			"0":
				pass # direct to house
			"1":
				pass # key one
	elif global.dungeon_keys != 0:
		match str(global.dungeon_current_stage):
			"1":
				pass # say to speak to her
			"2":
				pass # say concerns for her
