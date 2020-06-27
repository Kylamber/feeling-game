extends Node2D

# Nodes
onready var ysort: YSort = $ysort
onready var _obj_dungeon_door1: StaticBody2D = $ysort/obj_dungeon_door2
onready var _obj_dungeon_door2: StaticBody2D = $ysort/obj_dungeon_door
onready var node_minions: Node2D = $ysort/node_minions
onready var node_stage_one_spawn: Node2D = $node_stage_one_spawn
onready var node_stage_two_spawn: Node2D = $node_stage_two_spawn
onready var node_stage_three_spawn: Node2D = $node_stage_three_spawn


var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	global.register_dungeon(self)
	global.player.state = "pve"
	tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_wrath_enter"])
	match str(global.dungeon_current_stage):
		"0":
			spawn_minion(5, "node_stage_one_spawn")
		"1":
			spawn_minion(10, "node_stage_two_spawn")
		"2":
			_obj_dungeon_door1.queue_free() # Delete the first door
			audio.play("bgm_battle2")
			var wrath_sword = load("res://entities/entity_wrath_sword/entity_wrath_sword.tscn")
			var boss: KinematicBody2D = wrath_sword.instance()
			boss.position = node_stage_three_spawn.get_node("1").position
			ysort.add_child(boss)
	yield(get_tree().create_timer(4), "timeout")
	match global.system_language:
		"english":
			tooltips.show_tooltips("tooltips", "Click the screen to shoot out hearts")
		"indonesia":
			tooltips.show_tooltips("tooltips", "Klik di layar untuk menembakkan hati")


func spawn_minion(amount: int, spawn_node: String) -> void:
	var node_spawn = get_node(spawn_node)
	var nethink = load("res://entities/entity_feeling_minion/entity_feeling_minion.tscn")
	for i in range(amount):
		var enemies: KinematicBody2D = nethink.instance()
		var random_int = rng.randi_range(0, node_spawn.get_child_count() - 1)
		node_minions.add_child(enemies)
		enemies.position.x = node_spawn.get_node(str(random_int)).position.x + rng.randi_range(-20, 20)
		enemies.position.y = node_spawn.get_node(str(random_int)).position.y + rng.randi_range(-20, 20)


func dungeon_clear() -> void:
	if global.dungeon_current_stage == 2:
		tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_finished"])
	else:
		tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_room_finished"])
	global.dungeon_current_stage += 1
	yield(get_tree().create_timer(2), "timeout")
	global.player.state = "normal"
	fade.transition("res://maps/chapter1/chapter1-patient_house.tscn", 0.5, Vector2(72, 192))


func kill_minions() -> void:
	for node in node_minions.get_children():
		node.call_deferred("kill")
