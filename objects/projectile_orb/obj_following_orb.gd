extends KinematicBody2D

var motion: Vector2 = Vector2.ZERO
var dir: Vector2
const SPEED: int = 8 * 16


func _process(delta):
	if is_on_wall():
		queue_free()
	
	dir = global.player.position - position
	dir = dir.normalized()
	
	motion.x = SPEED * dir.x
	motion.y = SPEED * dir.y
	motion = move_and_slide(motion)


func _on_area_detect_player_body_entered(body):
	if body.has_method("damage"):
		body.call_deferred("damage", 1)
		queue_free()
	else:
		queue_free()
