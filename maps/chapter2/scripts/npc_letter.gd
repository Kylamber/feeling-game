extends Area2D

onready var dialogue_system: Node2D = $dialogue_system


func _ready():
	if global.dungeon_current_stage != 2:
		queue_free()
	else:
		show()


func _on_npc_letter_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	dialogue_system.selected_dialogue = "nokey-2"
	dialogue_system.dialogue_available = true


func _on_npc_letter_body_exited(body):
	dialogue_system.dialogue_available = false

