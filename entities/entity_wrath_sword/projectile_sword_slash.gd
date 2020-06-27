extends KinematicBody2D

var direction: Vector2 = Vector2.ZERO
const SPEED: int = 8 * 16
var motion: Vector2 = Vector2.ZERO


func _process(delta):
	if is_on_wall():
		queue_free()
	
	motion.x = SPEED * direction.x
	motion.y = SPEED * direction.y
	motion = move_and_slide(motion)


func _on_area_orb_dmg_body_entered(body):
	if body.has_method("damage"):
		body.call_deferred("damage", 1)
		queue_free()
