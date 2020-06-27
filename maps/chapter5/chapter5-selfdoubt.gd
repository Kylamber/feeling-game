extends Node2D


func _ready():
	global.player.state = "pve"
	audio.play("bgm_battle3")
	$dialogue_system.selected_dialogue = "0"
	$dialogue_system.dialogue_start()
