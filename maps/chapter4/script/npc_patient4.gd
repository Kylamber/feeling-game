extends Area2D

onready var dialogue_system: Node2D = $dialogue_system
export (String) var dialogue_transition
export (Vector2) var appear_location


func _ready():
	if global.dungeon_current_stage == 2 or global.dungeon_current_stage == 3:
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
	dialogue_system.dialogue_available = false
	global.dialogue_transition = ""


func select_dialogue():
	if global.dungeon_keys == 0:
		match global.dungeon_current_stage:
			0:
				dialogue_system.selected_dialogue = "nokey-0"
			1:
				dialogue_system.selected_dialogue = "nokey"
	elif global.dungeon_keys != 0:
		match global.dungeon_current_stage:
			1:
				dialogue_system.selected_dialogue = "havekey-1"
