extends Area2D

onready var dialogue_system: Node2D = $dialogue_system


func _on_npc_bystander_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	dialogue_system.dialogue_available = true
	select_dialogue()


func _on_npc_bystander_body_exited(body):
	dialogue_system.dialogue_available = false


func select_dialogue():
	if global.dungeon_current_stage == 0:
		dialogue_system.selected_dialogue = "nokey-0"
	else:
		dialogue_system.selected_dialogue = "default"
