extends KinematicBody2D

var jump_impulse = 500
var gravity = 50
var current_animation

var velocity = Vector2.ZERO
var is_jumping = false
var animation_state = "idle"


func _physics_process(delta):
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() and velocity.y <= 0.0 and $AnimationPlayer.current_animation != "prejump":
		$AnimationPlayer.play("idle")


	if not is_on_floor() and velocity.y >= 0.0:
		$AnimationPlayer.play("fall")


	if is_on_floor() and is_jumping:
		velocity.y = -jump_impulse
		$AnimationPlayer.play("jump")
		is_jumping = false


	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimationPlayer.play("prejump")


func apply_jump() -> void:
	is_jumping = true

