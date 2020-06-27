extends KinematicBody2D

onready var _animation_wrath_sword: AnimationPlayer = $animation_wrath_sword
onready var _animation_overlay_ws: AnimationPlayer = $animation_overlay_wrath_sword
onready var boss_attack: Node2D = $node_boss_attacks

var rng = RandomNumberGenerator.new()
var state: String = "idle"

const MAX_HEALTH = 9
var health = MAX_HEALTH setget _set_health


func _ready():
	_animation_wrath_sword.play("floating_sword")


func _process(delta):
	match state:
		"alive":
			if $timer.is_stopped():
				$timer.start()
				_stage_three()
		"dead":
			pass
		"idle":
			pass


func _stage_three() -> void:
	var atk_type = rng.randi_range(1,2)
	var loc = rng.randi_range(0, 6)
	_random_tp()
	match atk_type:
		1:
			_animation_wrath_sword.play("s1_atk_1")
			yield(_animation_wrath_sword, "animation_finished")
			radial_orb_bullet(10)
			yield(get_tree().create_timer(0.1), "timeout")
			radial_orb_bullet(10, 20)
		2:
			_animation_wrath_sword.play("s1_atk_2")
			yield(get_tree().create_timer(0.2), "timeout")
			radial_orb_bullet(8)
			yield(get_tree().create_timer(0.5), "timeout")
			radial_orb_bullet(8, 25)
			yield(get_tree().create_timer(0.5), "timeout")
			radial_orb_bullet(8, 50)
	_animation_wrath_sword.play("floating_sword")


# Health system
func damage(amount: int) -> void:
	if state != "dead":
		_set_health(health - amount)
		_animation_overlay_ws.play("damaged")
		boss_attack.play("sfx_tp")
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
	
	boss_attack.play("sfx_pew")
	
	for i in range(amount):
		var bullet: KinematicBody2D = slash_sword.instance()
		bullet.position = position
		get_parent().add_child(bullet)
		var projectile_dir: Vector2 = Vector2(sin((angle * PI)/180) * 5, cos((angle * PI)/180) * 5)
		bullet.direction = projectile_dir.normalized()
		angle += angle_step


func _random_tp() -> void:
	position = get_parent().get_node("node_spawn").get_node(str(rng.randi_range(0, 6))).position
	boss_attack.play("sfx_tp")
