extends Area2D


func _ready() -> void:
	if global.dungeon_current_stage == 2 and global.dungeon_keys == 0:
		show()
	else:
		queue_free()


func _on_area_letter_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	if global.dungeon_current_stage == 2 and global.dungeon_keys == 0:
		dialogue.dialogue_path = "res://dialogue/chapter2/letter-%s.json" % global.system_language


func _on_area_letter_body_exited(body):
	dialogue.dialogue_path = ""
