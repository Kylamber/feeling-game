extends Area2D


func _on_npc_enterance_body_entered(body):
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dialogue"])
	$dialogue_system.selected_dialogue = "default"
	$dialogue_system.dialogue_available = true


func _on_npc_enterance_body_exited(body):
	$dialogue_system.dialogue_available = false
