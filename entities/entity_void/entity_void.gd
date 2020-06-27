extends KinematicBody2D

# Nodes
onready var _animation_void: AnimationPlayer = $anim_void
onready var _aspr_void: Sprite = $spr_void
onready var _timer_stage_one: Timer = $timer_stage_one
onready var _timer_stage_two: Timer = $timer_stage_two
onready var _timer_stage_three: Timer = $timer_stage_three
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
			_aspr_void.play("signalling")
			_tp_to_player()
			yield(get_tree().create_timer(1), "timeout")
			_animation_void.play("void_attack")
		2:
			_aspr_void.play("signalling")
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(10)
			_animation_void.play("rest")


func _stage_two() -> void:
	var atk_type: int = rng.randi_range(1, 2)
	match atk_type:
		1:
			_aspr_void.play("signalling")
			_tp_to_player()
			yield(get_tree().create_timer(1), "timeout")
			_animation_void.play("void_attack")
		2:
			_aspr_void.play("signalling")
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6, 30)
			_animation_void.play("rest")


func _stage_three() -> void:
	var atk_type: int = rng.randi_range(1, 3)
	match atk_type:
		1:
			_aspr_void.play("signalling")
			_tp_to_player()
			yield(get_tree().create_timer(1), "timeout")
			_animation_void.play("void_attack")
			yield(_animation_void, "animation_finished")
			_tp_to_player()
			yield(get_tree().create_timer(0.5), "timeout")
			_animation_void.play("void_attack")
		2:
			_aspr_void.play("signalling")
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(6, 30)
			_animation_void.play("rest")
		3:
			_aspr_void.play("signalling")
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(3)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(3, 40)
			yield(get_tree().create_timer(0.3), "timeout")
			boss_attacks.radial_orb_bullet(3, 80)
			_animation_void.play("rest")

# Health system
func damage(amount: int) -> void:
	if state != "dead":
		_animation_void.seek(0, true)
		_set_health(health - amount)
		_animation_void.play("damaged")
		_random_tp()
		global.dungeon.spawn_minion(2, "node_stage_three_spawn")


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
	_animation_void.play("rest")
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_boss_defeated"])


func _random_tp() -> void:
	position = global.dungeon.get_node("node_stage_three_spawn").get_node(str(rng.randi_range(0, 5))).position
	boss_attacks.play("sfx_tp")


func _tp_to_player() -> void:
	position.x = global.player.position.x + rng.randi_range(-60, 60)
	position.y = global.player.position.y + rng.randi_range(-60, 60)


func _on_area_void_attack_body_entered(body) -> void:
	if body.has_method("damage"):
		body.call_deferred("damage", 1)


func _on_area_void_get_body_entered(body) -> void:
	if state == "dead":
		global.player.state = "zoom"
		tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["void_get"])
		global.dungeon.kill_minions()
		yield(get_tree().create_timer(4), "timeout")
		global.dungeon.dungeon_clear()
