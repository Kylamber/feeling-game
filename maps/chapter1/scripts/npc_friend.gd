extends Area2D

onready var dialogue_system: Node2D = $dialogue_system


func _on_npc_friend_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	dialogue_system.dialogue_available = true
	select_dialogue()


func _on_npc_friend_body_exited(body):
	dialogue_system.dialogue_available = false


func select_dialogue():
	if global.dungeon_keys == 0:
		match global.dungeon_current_stage:
			0:
				dialogue_system.selected_dialogue = "nokey-0"
			1:
				dialogue_system.selected_dialogue = "nokey-1"
			2:
				dialogue_system.selected_dialogue = "nokey-2"
	elif global.dungeon_keys != 0:
		match global.dungeon_current_stage:
			1, 2:
				dialogue_system.selected_dialogue = "havekey"
