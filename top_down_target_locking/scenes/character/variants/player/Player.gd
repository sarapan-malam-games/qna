extends "res://scenes/character/Character.gd"

export var movespeed := 200.0
export var field_of_view := 45.0
export var rotate_with_mouse := false

var desired_direction := Vector2.ZERO
var velocity := Vector2.ZERO

var nearest_enemy: KinematicBody2D


func _ready() -> void:
	get_parent().connect("draw", self, "_on_target_draw")


func _physics_process(delta: float) -> void:
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	velocity = direction * movespeed
	velocity = move_and_slide(velocity)
	
	nearest_enemy = get_nearest_enemy()

	if rotate_with_mouse:
		look_at(get_global_mouse_position())
		desired_direction = global_position.direction_to(get_global_mouse_position())
	else:
		if direction != Vector2.ZERO:
			desired_direction = direction
		rotation = lerp(rotation, desired_direction.angle(), 0.5)
	
	get_parent().update()
	update()


func get_nearest_enemy() -> KinematicBody2D:
	var nearest_enemy: KinematicBody2D
	var front_enemies := []
	
	for enemy in $AttackArea.get_overlapping_bodies():
#		get enemies in front of the player
#		to find out, look for angle to enemy using dot product
		var angle_to_node = rad2deg(acos(desired_direction.dot(global_position.direction_to(enemy.global_position))))
		if angle_to_node < field_of_view:
			front_enemies.append(enemy)
	
	
	if not front_enemies.empty():
		nearest_enemy = front_enemies[0]
		
		for enemy in front_enemies:
#			get enemies based on the closest distance
			if global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
				nearest_enemy = enemy

	return nearest_enemy


func _draw() -> void:
	draw_line(Vector2.ZERO, Vector2($AttackArea/CollisionShape2D.shape.radius, 0).rotated(deg2rad(field_of_view)), Color.green, 2.0)
	draw_line(Vector2.ZERO, Vector2($AttackArea/CollisionShape2D.shape.radius, 0).rotated(deg2rad(-field_of_view)), Color.green, 2.0)
	draw_arc(Vector2.ZERO, $AttackArea/CollisionShape2D.shape.radius, deg2rad(-field_of_view), deg2rad(field_of_view), 20, Color.green, 2.0)


func _on_target_draw() -> void:
	if nearest_enemy != null:
		get_parent().draw_circle(nearest_enemy.global_position, 30, Color.red)
