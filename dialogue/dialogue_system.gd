extends Node2D

# Nodes
onready var master_dialogue: Control = $dialogue_container/dialogue_control
onready var dialogue_picture: TextureRect = $dialogue_container/dialogue_control/container_dialogue/dialogue_box/dialogue_picture
onready var dialogue_text: Label = $dialogue_container/dialogue_control/container_dialogue/dialogue_box/dialogue_text
onready var dialogue_animation: AnimationPlayer = $dialogue_container/dialogue_animation

export (bool) var enabled = true
export (String) var boss

var selected_dialogue = ""
var dialogue_available = false
var current_line = 0
var active = false
var current_language = 0


func _ready():
	master_dialogue.hide()


func dialogue_start():
	master_dialogue.show()
	active = true
	global.player.state = "dialogue"
	dialogue_setlanguage()
	dialogue_update()


func dialogue_update():
	dialogue_set()
	dialogue_animation.play("show_text")


func next_dialogue():
	current_line += 1
	dialogue_animation.seek(0, true)
	if current_line < get_node(selected_dialogue).dialogue_lines[current_language].size():
		dialogue_update()
	else:
		dialogue_stop()


func dialogue_stop():
	master_dialogue.hide()
	dialogue_animation.play("rest")
	dialogue_available = false
	active = false
	dialogue_commands()
	current_line = 0
	global.player.state = "dialogue_finished"


func dialogue_commands():
	match get_node(selected_dialogue).dialogue_command:
		"give_key":
			global.dungeon_keys += 1
			tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["key_found"])
		"transition":
			fade.transition(global.dialogue_transition, 0.5, global.player_appear_location)
		"next_level":
			fade.transition(save_and_load.data["level"]["next_level_path"])
		"enable_boss":
			get_parent().get_node(boss).state = "alive"
			global.state_to_pve = true


func dialogue_set():
	dialogue_text.text = get_node(selected_dialogue).dialogue_lines[current_language][current_line]
	if get_node(selected_dialogue).dialogue_picture_resource[current_line]:
		dialogue_picture.texture = get_node(selected_dialogue).dialogue_picture_resource[current_line]
	else:
		pass


func dialogue_setlanguage():
	match global.system_language:
		"indonesia":
			current_language = 0
		"english":
			current_language = 1


func _input(event):
	if Input.is_action_just_pressed("ui_accept") and enabled:
		if dialogue_available and !active:
			dialogue_start()
		elif active:
			next_dialogue()

