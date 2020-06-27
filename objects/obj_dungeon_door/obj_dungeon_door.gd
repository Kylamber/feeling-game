extends StaticBody2D

onready var _sfx_door := $sfx_door

var enabled: bool = false


func _on_area_key_acc_body_entered(body):
	_sfx_door.play()
	if global.dungeon_keys != 0:
		queue_free()
		tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_door"])
		global.dungeon_keys -= 1
	
	elif global.dungeon_keys == 0 and !enabled:
		enabled = true
		match global.system_language:
			"english":
				tooltips.show_tooltips("tooltips", "Locked")
			"indonesia":
				tooltips.show_tooltips("tooltips", "Terkunci")
		global.dungeon.kill_minions()
		yield(get_tree().create_timer(4), "timeout")
		global.dungeon.dungeon_clear()

