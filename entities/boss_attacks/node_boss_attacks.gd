extends Node2D

# Attacks
func radial_orb_bullet(amount: int, increment: int = 0) -> void:
	var slash_sword = load("res://objects/projectile_orb/projectile_orb.tscn")
	amount -= 1
	var angle_step: float = 360/amount
	var angle: int = increment
	
	play("sfx_pew")
	
	for i in range(amount):
		var bullet: KinematicBody2D = slash_sword.instance()
		bullet.position = get_parent().position
		global.dungeon.ysort.add_child(bullet)
		var projectile_dir: Vector2 = Vector2(sin((angle * PI)/180) * 5, cos((angle * PI)/180) * 5)
		bullet.direction = projectile_dir.normalized()
		angle += angle_step


func follow_orb_bullet(amount: int) -> void:
	var slash_sword = load("res://objects/projectile_orb/obj_following_orb.tscn")
	amount -= 1
	
	play("sfx_pew")
	
	for i in range(amount):
		var bullet: KinematicBody2D = slash_sword.instance()
		bullet.position = get_parent().position
		global.dungeon.ysort.add_child(bullet)
		yield(get_tree().create_timer(0.2), "timeout")


# Audio
func play(sfx = null) -> void:
	if sfx:
		get_node("sfx").get_node(sfx).play()
