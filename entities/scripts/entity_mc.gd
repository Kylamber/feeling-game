extends KinematicBody2D

# Signals
signal health_changed(health)

# Nodes
onready var cam_mc: Camera2D = $cam_mc
onready var _animation_mc: AnimationPlayer = $animation_entity_mc
onready var _timer_invulnerable: Timer = $timer_invulnerable
onready var _collision_mc: CollisionShape2D = $col_mc
onready var _aspr_mc: AnimatedSprite = $spr_mc

# Sfx
onready var _audio_hit: AudioStreamPlayer2D = $sfx/audio_hit
onready var _audio_shoot: AudioStreamPlayer2D = $sfx/audio_shoot

# Animation variable
var orient_anim: bool = false

# Movement variable
var input_axis: Vector2 = Vector2.ZERO
var motion: Vector2 = Vector2.ZERO
const MAX_SPEED: int = 4 * 16
const ACCELERATION: int = 256

# Health
var max_health: int = save_and_load.data["player"]["max_health"]
var health = max_health setget _set_health

var state: String = "normal"
var weapon: String = "unarmed"


func _ready():
	# Register player
	global.register_player(self)
	
	# Set camera limit size
	var tilemap_rect: Rect2 = global.tile_used_rect
	var tilemap_cell_size: Vector2 = global.tile_cell_size
	cam_mc.limit_left = tilemap_rect.position.x * tilemap_cell_size.x
	cam_mc.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	cam_mc.limit_top = tilemap_rect.position.y * tilemap_cell_size.y
	cam_mc.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
	
	# Set teleport location
	position = global.player_appear_location


func _process(delta):
	match state:
		"normal":
			_movement(delta)
		"pve":
			_movement(delta)
		"dialogue":
			motion.x = 0
			motion.y = 0
			cam_mc.zoom.x = lerp(cam_mc.zoom.x, 0.75, 0.1)
			cam_mc.zoom.y = lerp(cam_mc.zoom.y, 0.75, 0.1)
		"dialogue_finished":
			cam_mc.zoom.x = lerp(cam_mc.zoom.x, 1, 0.1)
			cam_mc.zoom.y = lerp(cam_mc.zoom.y, 1, 0.1)
			yield(get_tree().create_timer(0.5), "timeout")
			if global.state_to_pve:
				state = "pve"
			else:
				state = "normal"
		"zoom":
			motion.x = 0
			motion.y = 0
			cam_mc.zoom.x = lerp(cam_mc.zoom.x, 0.75, 0.1)
			cam_mc.zoom.y = lerp(cam_mc.zoom.y, 0.75, 0.1)
			yield(get_tree().create_timer(3), "timeout")
			cam_mc.zoom.x = lerp(cam_mc.zoom.x, 1, 0.1)
			cam_mc.zoom.y = lerp(cam_mc.zoom.y, 1, 0.1)
			state = "normal"
		"dead":
			motion.x = 0
			motion.y = 0
			
	_set_anim()
	_key_input()
	_mouse_input()

# State
func _movement(delta) -> void:
	input_axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input_axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	motion.x += input_axis.x * ACCELERATION * delta # Add speed
	motion.y += input_axis.y * ACCELERATION * delta
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED) # Clamp speed
	motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)
	
	if input_axis.x == 0:
		motion.x = lerp(motion.x, 0, 0.7)
	if input_axis.y == 0:
		motion.y = lerp(motion.y, 0, 0.7)
	motion = move_and_slide(motion)

# PVE mechanics
func damage(amount) -> void:
	_set_health(health - amount)
	_audio_hit.play()


func _set_health(value) -> void:
	var prev_health: int = health
	health = clamp(value, 0, max_health)
	if prev_health != health:
		if health != 0:
			_animation_mc.play("invulnerable")
			set_collision_mask_bit(2, false)
			_timer_invulnerable.start()
			emit_signal("health_changed", health)
		elif health == 0:
			_kill()


func _kill() -> void:
	tooltips.show_tooltips("dark_overlay", "Game Over")
	state = "dead"
	_collision_mc.disabled = true
	yield(get_tree().create_timer(4), "timeout") # Return to camp
	fade.transition(save_and_load.data["level"]["level_path"], 0.5, Vector2(save_and_load.data["level"]["posx"], save_and_load.data["level"]["posy"]))
	state = "normal"


func _shoot_projectile(dir: Vector2) -> void:
	_audio_shoot.play()
	var projectile_heart = load("res://entities/entity_mc/projectile_heart.tscn")
	var bullet: KinematicBody2D = projectile_heart.instance()
	get_parent().add_child(bullet)
	bullet.direction = dir
	bullet.position = position


func _on_timer_invulnerable_timeout() -> void:
	_animation_mc.play("rest")
	set_collision_mask_bit(2, true)

# Animations
func _set_anim() -> void:
	if input_axis.x == 1:
		orient_anim = false
	elif input_axis.x == -1:
		orient_anim = true
	if input_axis.x != 0 || input_axis.y != 0:
		_anim("run")
	if input_axis.x == 0 && input_axis.y == 0:
		_anim("idle")


func _anim(animation: String, backwards = false) -> void:
	_aspr_mc.play(animation, backwards)
	_aspr_mc.flip_h = orient_anim

# Inputs
func _key_input() -> void:
	# Dialogue
#	if dialogue.dialogue_path != "" and Input.is_action_just_pressed("ui_accept") and state != "dialogue":
#		dialogue.start_dialogue()
#	elif state == "dialogue" and Input.is_action_just_pressed("ui_accept"):
#		dialogue.next_dialogue()
	pass


func _mouse_input() -> void:
	# Shooting projectile
	if Input.is_action_just_pressed("lmb_click") and weapon == "unarmed" and state == "pve":
		var projectile_dir = get_global_mouse_position() - position
		_shoot_projectile(projectile_dir.normalized())
