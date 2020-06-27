extends Node2D


func _ready() -> void:
	pause.pausable = true
	audio.play("bgm_tundra")
	if global.dungeon_current_stage == 0:
		if global.system_language == "english":
			tooltips.show_tooltips("title", "Chapter 2 :", "Lone")
		elif global.system_language == "indonesia":
			tooltips.show_tooltips("title", "Bab 2 :", "Kesendirian")

