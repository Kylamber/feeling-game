extends Node2D


func _ready():
	audio.play("bgm_propehecy")
	pause.pausable = true
	if global.dungeon_current_stage == 0:
		if global.system_language == "english":
			tooltips.show_tooltips("title", "Chapter 4 :", "Depression")
		elif global.system_language == "indonesia":
			tooltips.show_tooltips("title", "Bab 4 :", "Depresi")


