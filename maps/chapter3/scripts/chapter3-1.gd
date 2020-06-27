extends Node2D

onready var _night_overlay: CanvasModulate = $CanvasModulate


func _ready():
	audio.play("bgm_werewolf")
	pause.pausable = true
	if global.dungeon_current_stage == 2:
		_night_overlay.hide()
	if global.dungeon_current_stage == 0:
		if global.system_language == "english":
			tooltips.show_tooltips("title", "Chapter 3 :", "Nyctophobia")
		elif global.system_language == "indonesia":
			tooltips.show_tooltips("title", "Bab 3 :", "Nyctophobia")


