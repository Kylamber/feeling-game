extends Node

var pausable: bool

var tile_used_rect: Rect2
var tile_cell_size: Vector2

# Player variables
var player
var player_appear_location: Vector2
var dialogue_transition: String
var state_to_pve: bool

# Dungeon variables
var dungeon
var dungeon_current_stage: int
var dungeon_keys: int
var dungeon_boss_killed: bool

# Settings
var system_language: String = ""


func register_player(p):
	player = p


func register_dungeon(d):
	dungeon = d
