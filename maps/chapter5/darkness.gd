extends KinematicBody2D

# Nodes
onready var _aspr_dark_being: Sprite = $aspr_dark_being
onready var _timer_stage_three: Timer = $node_timers/timer_stage_three
onready var boss_attacks: Node2D = $node_boss_attacks
onready var _col_dark_being: CollisionShape2D = $col_dark_being

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var state: String = "idle"

const MAX_HEALTH:int = 9
var health:int = MAX_HEALTH setget _set_health


func _process(delta) -> void:
	match state:
		"alive":
			if _timer_stage_three.is_stopped():
				_timer_stage_three.start()
				_aspr_dark_being.play("idle")
				_stage_three()
		"dead":
			pass
		"idle":
			pass


func _stage_three() -> void:
	var atk_type: int = rng.randi_range(1, 3)
	match atk_type:
		1:
			radial_orb_bullet(6)
			yield(get_tree().create_timer(0.3), "timeout")
			radial_orb_bullet(6, 30)
		2:
			radial_orb_bullet(3)
			yield(get_tree().create_timer(0.3), "timeout")
			radial_orb_bullet(3, 40)
			yield(get_tree().create_timer(0.3), "timeout")
			radial_orb_bullet(3, 80)
		3:
			follow_orb_bullet(3)
			yield(get_tree().create_timer(1), "timeout")
			follow_orb_bullet(3)
	_aspr_dark_being.play("idle")

# Health system
func damage(amount: int) -> void:
	if state != "dead":
		_set_health(health - amount)
		_col_dark_being.disabled = true
		_aspr_dark_being.play("tp")
		yield($aspr_dark_being, "animation_finished")
		_aspr_dark_being.play("tp", true)
		_col_dark_being.disabled = false
		_random_tp()


func _set_health(value: int) -> void:
	var prev_health: int = health
	health = clamp(value, 0, MAX_HEALTH)
	if health == 0:
		_kill()


func _kill() -> void:
	state = "dead"
	global.dungeon_boss_killed = true
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_boss_defeated2"])
	queue_free()


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


func _random_tp() -> void:
	position = get_parent().get_node("node_spawn").get_node(str(rng.randi_range(0, 6))).position
	boss_attacks.play("sfx_tp")

