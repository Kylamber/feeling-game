extends StaticBody2D


func _ready():
	pass # Replace with function body.


func _on_area_door_body_entered(body):
	if global.dungeon_boss_killed:
		tooltips.show_tooltips("tooltips", tooltips.tool_tips[global.system_language]["dungeon_door"])
		global.dungeon_boss_killed = false
		queue_free()
	else:
		tooltips.show_tooltips("tooltips", "Locked")
