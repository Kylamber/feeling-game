extends CanvasLayer

onready var _spr_health: Sprite = $spr_heart


func _ready():
	_spr_health.frame = 14 - save_and_load.data["player"]["max_health"]


func _on_entity_mc_health_changed(health):
	_spr_health.frame = 14 - health
