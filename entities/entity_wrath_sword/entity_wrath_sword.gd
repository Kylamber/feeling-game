extends KinematicBody2D

# Attacks
onready var boss_attack: Node2D = $node_boss_attacks

# Nodes
onready var _timer_stage_one: Timer = $timer_stage_one
onready var _timer_stage_two: Timer = $timer_stage_two
onready var _timer_stage_three: Timer = $timer_stage_three
onready var _animation_wrath_sword: AnimationPlayer = $animation_wrath_sword
onready var _animation_overlay_ws: AnimationPlayer = $animation_overlay_wrath_sword
onready var boss_sfx: Node = $node_sfx

var state: String = "stage_one"

const MAX_HEALTH: int = 3
var health: int = MAX_HEALTH setget _set_health

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_animation_wrath_sword.play("floating_sword")


func _process(delta) -> void:
	match state:
		"stage_one":
			if _timer_stage_one.is_stopped():
				_timer_stage_one.start()
				_stage_one()
		"stage_two":
			if _timer_stage_two.is_stopped():
				_timer_stage_two.start()
				_stage_two()
		"stage_three":
			if _timer_stage_three.is_stopped():
				_timer_stage_three.start()
				_stage_three()
		"dead":
			pass

# Stage timers
func _stage_one() -> void:
	var atk_type = rng.randi_range(1,2)
	match atk_type:
		1:
			_animation_wrath_sword.play("s1_atk_1")
			yield(_animation_wrath_sword, "animation_finished")
			boss_attack.radial_orb_bullet(10)
		2:
			_animation_wrath_sword.play("s1_atk_2")
			yield(get_tree().create_timer(0.2), "timeout")
			boss_attack.radial_orb_bullet(8)
			yield(get_tree().create_timer(0.5), "timeout")
			boss_attack.radial_orb_bullet(8)
			yield(get_tree().create_timer(0.5), "timeout")
			boss_attack.radial_orb_bullet(8)
	_animation_wrath_sword.play("floating_sword")


func _stage_two() -> void:
	var atk_type = rng.randi_range(1,2)
	# Debug
	print("Wrath Sword : Attack type " + str(atk_type))
	match atk_type:
		1:
			_animation_wrath_sword.play("s1_atk_1")
			yield(_animation_wrath_sword, "animation_finished")
			boss_attack.radial_orb_bullet(10)
		2:
			_animation_wrath_sword.play("s1_atk_2")
			yield(get_tree().create_timer(0.2), "timeout")
			boss_attack.radial_orb_bullet(8)
			yield(get_tree().create_timer(0.5), "timeout")
			boss_attack.radial_orb_bullet(8, 25)
			yield(get_tree().create_timer(0.5), "timeout")
			boss_attack.radial_orb_bullet(8, 50)
	_animation_wrath_sword.play("floating_sword")


func _stage_three() -> void:
	var atk_type = rng.randi_range(1,2)
	var loc = rng.randi_range(0, 7)
	# Debug
	print("Wrath sword : Attack type " + str(atk_type))
	print("Wrath sword : Location " + str(loc))
	self.position = get_parent().get_parent().get_node("node_stage_three_spawn").get_node(str(loc)).position
	global.dungeon.spawn_minion(1, "node_stage_three_spawn")
	match atk_type:
		1:
			_animation_wrath_sword.play("s1_atk_1")
			yield(_animation_wrath_sword, "animation_finished")
			boss_attack.radial_orb_bullet(10)
			yield(get_tree().create_timer(0.1), "timeout")
			boss_attack.radial_orb_bullet(10, 20)
		2:
			_animation_wrath_sword.play("s1_atk_2")
			yield(get_tree().create_timer(0.2), "timeout")
			boss_attack.radial_orb_bullet(8)
			yield(get_tree().create_timer(0.5), "timeout")
			boss_attack.radial_orb_bullet(8, 25)
			yield(get_tree().create_timer(0.5), "timeout")
			boss_attack.radial_orb_bullet(8, 50)
	_animation_wrath_sword.play("floating_sword")

# Health system
func damage(amount: int) -> void:
	if state != "dead":
		_set_health(health - amount)
		_animation_overlay_ws.play("damaged")
		boss_attack.play("sfx_tp")
		position = global.dungeon.get_node("node_stage_three_spawn").get_node(str(rng.randi_range(0, 7))).position


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
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_boss_defeated"])


# Functions
func _on_area_detect_player_body_entered(body) -> void:
	if state == "dead":
		global.player.state = "zoom"
		tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["wrath_sword_get"])
		global.dungeon.kill_minions()
		yield(get_tree().create_timer(4), "timeout")
		global.dungeon.dungeon_clear()
