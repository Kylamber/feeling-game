extends Control

onready var label: Label = $TextureRect/Label
onready var dialogue_lines = $dialogue_holder.dialogue_lines

var lang: int = 0
var current_dialogue: int


func _ready():
	pause.pausable = false
	$AnimationPlayer.play("bg")
	yield(get_tree().create_timer(0.5), "timeout")
	for i in range(0, dialogue_lines[lang].size()):
		$label.seek(0, true)
		$label.play("labelanim")
		label.text = dialogue_lines[lang][i]
		yield($label, "animation_finished")
		yield(get_tree().create_timer(2), "timeout")
	save_and_load.reset_data()
	fade.transition("res://ui/start_menu.tscn")


func select_language():
	match global.system_language:
		"indonesia":
			lang = 0
		"english":
			lang = 1



