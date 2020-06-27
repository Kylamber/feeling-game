extends KinematicBody2D

# Nodes
onready var _aspr_darkcat: Sprite = $aspr_darkcat
onready var _timer_stage_one: Timer = $node_timer/timer_stage_one
onready var _timer_stage_two: Timer = $node_timer/timer_stage_two
onready var _timer_stage_three: Timer = $node_timer/timer_stage_three
onready var boss_attacks: Node2D = $node_boss_attacks


var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var state: String = "stage_one"

const MAX_HEALTH:int = 3
var health:int = MAX_HEALTH setget _set_health


func _process(delta) -> void:
	match state:
		"stage_one":
			if _timer_stage_one.is_stopped():
				_timer_stage_one.start()
				_stage_one()
		"stage_two":
			if _timer_stage_two.is_stopped():
				_timer_stage_two.start()
				_stage_three()
		"stage_three":
			if _timer_stage_three.is_stopped():
				_timer_stage_three.start()
				_stage_three()
		"dead":
			pass

 
func _stage_one() -> void:
	var atk_type: int = rng.randi_range(1, 2)
	match atk_type:
		1:
			_aspr_darkcat.play("attack")
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6, 30)
		2:
			_aspr_darkcat.play("attack")
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(10)
	_aspr_darkcat.play("idle")


func _stage_two() -> void:
	var atk_type: int = rng.randi_range(1, 2)
	match atk_type:
		1:
			_aspr_darkcat.play("attack")
			_tp_to_player()
			yield(get_tree().create_timer(0.5), "timeout")
			boss_attacks.radial_orb_bullet(6)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6, 30)
		2:
			_aspr_darkcat.play("attack")
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6, 30)
	_aspr_darkcat.play("idle")


func _stage_three() -> void:
	var atk_type: int = rng.randi_range(1, 3)
	match atk_type:
		1:
			_aspr_darkcat.play("attack")
			_tp_to_player()
			yield(get_tree().create_timer(0.5), "timeout")
			boss_attacks.radial_orb_bullet(6)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6, 30)
		2:
			_aspr_darkcat.play("attack")
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6, 30)
		3:
			_aspr_darkcat.play("attack")
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(3)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(3, 40)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(3, 80)
	_aspr_darkcat.play("idle")

# Health system
func damage(amount: int) -> void:
	if state != "dead":
		_set_health(health - amount)
		_random_tp()
		global.dungeon.spawn_minion(2, "node_stage_two_spawn")


func _set_health(value: int) -> void:
	var prev_health: int = health
	health = clamp(value, 0, MAX_HEALTH)
	if health == 0 and state == "stage_one":
		state = "stage_two"
		health = MAX_HEALTH
	elif health == 0 and state == "stage_two":
		state = "stage_three"
		health = MAX_HEALTH
	elif health == 0 and state == "stage_three":
		_kill()


func _kill() -> void:
	state = "dead"
	_aspr_darkcat.play("idle")
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_boss_defeated"])


func _random_tp() -> void:
	position = global.dungeon.get_node("node_stage_two_spawn").get_node(str(rng.randi_range(0, 4))).position
	boss_attacks.play("sfx_tp")


func _tp_to_player() -> void:
	position.x = global.player.position.x + rng.randi_range(30, -30)
	position.y = global.player.position.y + rng.randi_range(30, -30)
	boss_attacks.play("sfx_tp")


func _on_area_detect_player_body_entered(body):
	if state == "dead":
		global.player.state = "zoom"
		tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["darkcat_get"])
		global.dungeon.kill_minions()
		yield(get_tree().create_timer(4), "timeout")
		global.dungeon.dungeon_clear()
