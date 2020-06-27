extends Area2D

onready var dialogue_system: Node2D = $dialogue_system

export (String) var dialogue_transition
export (Vector2) var appear_location


func _ready():
	if global.dungeon_current_stage >= 1:
		position = Vector2(40, 96)


func _on_npc_patient3_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	dialogue_system.dialogue_available = true
	global.dialogue_transition = dialogue_transition
	global.player_appear_location = appear_location
	select_dialogue()


func _on_npc_patient3_body_exited(body):
	global.dialogue_transition = ""
	dialogue_system.dialogue_available = false


func select_dialogue():
	match str(global.dungeon_current_stage):
		"0":
			dialogue_system.selected_dialogue = "nokey-0"
		"1":
			dialogue_system.selected_dialogue = "nokey-1" 
		"2":
			dialogue_system.selected_dialogue = "nokey-2" 
