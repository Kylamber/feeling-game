extends KinematicBody2D

# Nodes
onready var _particle_minion_death: Particles2D = $particle_entity_feeling_minion_death
onready var _spr_feeling_minion: Sprite = $spr_feeling_minion
onready var _collision_attack: CollisionShape2D = $area_attack/col_area_attack

# Animation variable
var orient_anim: bool = false

# Movement variable
var dir: Vector2 = Vector2.ZERO
var motion: Vector2 = Vector2.ZERO
const MAX_SPEED: int = 4 * 16
const ACCELERATION: int = 256

# Health variable
const MAX_HEALTH: int = 1
var health: int = MAX_HEALTH setget _set_health

# State machine
var state: String = "idle"


func _process(delta) -> void:
	match state:
		"idle":
			motion.x = 0
			motion.y = 0
		"chase":
			_movement(delta)
	_set_anim()

# State machines
func _movement(delta) -> void:
	_detect_player()
	
	motion.x += dir.x * ACCELERATION * delta # Add speed
	motion.y += dir.y * ACCELERATION * delta
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED) # Clamp speed
	motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)
	
	if dir.x == 0:
		motion.x = lerp(motion.x, 0, 0.7)
	if dir.y == 0:
		motion.y = lerp(motion.y, 0, 0.7)
	motion = move_and_slide(motion)

# PVE mechanics
func _detect_player() -> void:
	if global.player.position.x > position.x:
		dir.x = 1
	elif global.player.position.x < position.x:
		dir.x = -1
	
	if global.player.position.y > position.y:
		dir.y = 1
	elif global.player.position.y < position.y:
		dir.y = -1


func _on_area_attack_body_entered(body) -> void:
	if body.has_method("damage"):
		body.call_deferred("damage", 1)

# Health mechanics
func damage(amount: int) -> void:
	_set_health(health - amount)


func _set_health(value) -> void:
	var prev_health: int = health
	health = clamp(value, 0, MAX_HEALTH)
	if prev_health != health:
		if health == 0:
			kill()


func kill() -> void:
	_particle_minion_death.emitting = true
	_spr_feeling_minion.visible = false
	_collision_attack.disabled = true
	yield(get_tree().create_timer(0.5), "timeout")
	self.queue_free()

# Animations
func _set_anim() -> void:
	if state == "chase":
		_anim("run")
	elif state == "idle":
		_anim("idle")
	
	if dir.x == 1:
		orient_anim = false
	elif dir.x == -1:
		orient_anim = true

func _anim(animation: String, backwards: bool = false) -> void:
	_spr_feeling_minion.play(animation, backwards)
	_spr_feeling_minion.flip_h = orient_anim

