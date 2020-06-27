extends Area2D

func _on_area_detect_player_body_entered(body):
	get_parent().state = "chase"

func _on_area_detect_player_body_exited(body):
	get_parent().state = "idle"
