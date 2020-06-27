extends KinematicBody2D

# Nodes
onready var boss_attacks: Node2D = $node_boss_attacks
onready var anim_atk: AnimationPlayer = $anim_atk
onready var timer_stage_one: Timer = $node_timer/timer_stage_one
onready var timer_stage_two: Timer = $node_timer/timer_stage_two
onready var timer_stage_three: Timer = $node_timer/timer_stage_three


var rng = RandomNumberGenerator.new()

var state: String = "idle"
const MAX_HEALTH: int = 6
var health = MAX_HEALTH setget _set_health


func _process(delta):
	match state:
		"alive":
			if timer_stage_one.is_stopped():
				timer_stage_one.start()
				_stage_one()
		"stage_two":
			if timer_stage_two.is_stopped():
				timer_stage_two.start()
				_stage_two()
		"stage_three":
			if timer_stage_three.is_stopped():
				timer_stage_three.start()
				_stage_three()
		"dead":
			pass
		"idle":
			pass


func _stage_one() -> void:
	var atk_type: int = rng.randi_range(1, 2)
	_random_tp()
	match atk_type:
		1:
			radial_orb_bullet(10)
			yield(get_tree().create_timer(0.1), "timeout")
			radial_orb_bullet(10, 20)
		2:
			yield(get_tree().create_timer(0.2), "timeout")
			radial_orb_bullet(8)
			yield(get_tree().create_timer(0.5), "timeout")
			radial_orb_bullet(8, 25)
			yield(get_tree().create_timer(0.5), "timeout")
			radial_orb_bullet(8, 50)


func _stage_two() -> void:
	var atk_type: int = rng.randi_range(1, 2)
	
	match atk_type:
		1:
			_tp_to_player()
			anim_atk.play("void_atk")
			yield(anim_atk, "animation_finished")
			_tp_to_player()
			anim_atk.play("void_atk")
		2:
			follow_orb_bullet(1)
			yield(get_tree().create_timer(0.2), "timeout")
			follow_orb_bullet(1)
			yield(get_tree().create_timer(0.2), "timeout")
			follow_orb_bullet(1)
			yield(get_tree().create_timer(0.2), "timeout")
			follow_orb_bullet(1)
			yield(get_tree().create_timer(0.2), "timeout")
			follow_orb_bullet(1)


func _stage_three() -> void:
	var atk_type: int = rng.randi_range(1, 3)
	
	match atk_type:
		1:
			_tp_to_player()
			anim_atk.play("void_atk")
			yield(anim_atk, "animation_finished")
			_tp_to_player()
			anim_atk.play("void_atk")
		2:
			follow_orb_bullet(1)
			yield(get_tree().create_timer(0.2), "timeout")
			follow_orb_bullet(1)
			yield(get_tree().create_timer(0.2), "timeout")
			follow_orb_bullet(1)
		3:
			_random_tp()
			yield(get_tree().create_timer(0.2), "timeout")
			radial_orb_bullet(8)
			yield(get_tree().create_timer(0.5), "timeout")
			radial_orb_bullet(8, 25)
			yield(get_tree().create_timer(0.5), "timeout")
			radial_orb_bullet(8, 50)

# Health system
func damage(amount: int) -> void:
	if state != "dead":
		_set_health(health - amount)
		_random_tp()


func _set_health(value: int) -> void:
	var prev_health: int = health
	health = clamp(value, 0, MAX_HEALTH)
	if health == 0 and state == "alive":
		state = "stage_two"
		health = MAX_HEALTH
	elif health == 0 and state == "stage_two":
		state = "stage_three"
		health = MAX_HEALTH
	elif health == 0 and state == "stage_three":
		_kill()


func _kill() -> void:
	state = "dead"
	global.dungeon_boss_killed = true
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_boss_defeated"])


func _random_tp() -> void:
	position = get_parent().get_node("node_spawn").get_node(str(rng.randi_range(0, 6))).position
	boss_attacks.play("sfx_tp")


func _tp_to_player() -> void:
	position.x = global.player.position.x + rng.randi_range(-30, 30)
	position.y = global.player.position.y + rng.randi_range(-30, 30)


func radial_orb_bullet(amount: int, increment: int = 0) -> void:
	var slash_sword = load("res://objects/projectile_orb/projectile_orb.tscn")
	amount -= 1
	var angle_step: float = 360/amount
	var angle: int = increment
	
	boss_attacks.play("sfx_pew")
	
	for i in range(amount):
		var bullet: KinematicBody2D = slash_sword.instance()
		bullet.position = position
		get_parent().add_child(bullet)
		var projectile_dir: Vector2 = Vector2(sin((angle * PI)/180) * 5, cos((angle * PI)/180) * 5)
		bullet.direction = projectile_dir.normalized()
		angle += angle_step


func follow_orb_bullet(amount: int) -> void:
	var slash_sword = load("res://objects/projectile_orb/obj_following_orb.tscn")
	amount -= 1
	
	boss_attacks.play("sfx_pew")
	
	for i in range(amount):
		var bullet: KinematicBody2D = slash_sword.instance()
		bullet.position = position
		get_parent().add_child(bullet)
		yield(get_tree().create_timer(0.2), "timeout")


func dungeon_clear() -> void:
	tooltips.show_tooltips("tooltips", "E n d")
	yield(get_tree().create_timer(2), "timeout")
	global.player.state = "normal"
	fade.transition("res://maps/chapter5/chapter5-end.tscn")


func _on_area_void_attack_body_entered(body):
	if body.has_method("damage"):
		body.call_deferred("damage", 1)


func _on_area_defeated_body_entered(body):
	if state == "dead":
		dungeon_clear()
