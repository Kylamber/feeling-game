extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	global.player.state = "pve"
	$dialogue_system.selected_dialogue = "0"
	$dialogue_system.dialogue_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
