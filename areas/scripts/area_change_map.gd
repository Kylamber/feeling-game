extends Area2D

export var destination = ""
export var location = Vector2.ZERO


func _on_area_change_map_body_entered(body):
	fade.transition(destination, 0.5, location)
