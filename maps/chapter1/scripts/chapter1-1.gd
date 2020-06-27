extends Node2D


func _ready() -> void:
	audio.play("bgm_clockwork")
	if global.dungeon_current_stage == 0:
		if global.system_language == "english":
			tooltips.show_tooltips("title", "Chapter 1 :", "Wrath")
		elif global.system_language == "indonesia":
			tooltips.show_tooltips("title", "Bab 1 :", "Amarah")

