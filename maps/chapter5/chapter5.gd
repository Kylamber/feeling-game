extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pause.pausable = true
	audio.play("bgm_softtension")
	if global.dungeon_current_stage == 0:
		if global.system_language == "english":
			tooltips.show_tooltips("title", "Chapter 5 :", "Self doubt")
		elif global.system_language == "indonesia":
			tooltips.show_tooltips("title", "Bab 5 :", "Keraguan")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
