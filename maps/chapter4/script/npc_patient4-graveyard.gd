extends Area2D

onready var dialogue_system: Node2D = $dialogue_system
export (String) var dialogue_transition
export (Vector2) var appear_location


func _ready():
	if global.dungeon_current_stage < 2:
		queue_free()
	else:
		pass


func _on_npc_patient4_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	dialogue_system.dialogue_available = true
	global.dialogue_transition = dialogue_transition
	global.player_appear_location = appear_location
	select_dialogue()


func _on_npc_patient4_body_exited(body):
	global.dialogue_transition = ""
	dialogue_system.dialogue_available = false


func select_dialogue():
	match global.dungeon_current_stage:
		2:
			dialogue_system.selected_dialogue = "nokey-2"
		3:
			dialogue_system.selected_dialogue = "nokey-3"
