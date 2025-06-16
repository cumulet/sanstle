class_name PlayerBehaviour
extends CharacterBody3D

@export var is_selected: bool
@export var movement_speed := 2.0
@export var acceleration := 2.0
@export var friction := 2.0
@export var rotation_speed := 15.0
@onready var animation_player: AnimationPlayer = $character/AnimationPlayer
@onready var camera_3d: Camera3D = $"../Camera3D"

func character_movement(delta:float,x_input:float, y_input:float):
	if x_input == 0 and y_input == 0:
		# slow down
		velocity = velocity.lerp(
			Vector3.ZERO, delta * friction
		)
		animation_player.play("Armature|Idle")
		move_and_slide()
		return

	# 3) Build a local stick-vector and normalize
	var stick_vec = Vector3(x_input, 0, y_input).normalized()

	# 4) Get camera-relative forward/right
	var cam_basis = camera_3d.global_transform.basis
	var forward = -cam_basis.z
	forward.y = 0
	forward = forward.normalized()
	var right = cam_basis.x
	right.y = 0
	right = right.normalized()

	# 5) Compute world movement direction & target velocity
	var world_dir = (right * stick_vec.x + forward * stick_vec.z).normalized()
	var target_vel = world_dir * movement_speed

	# smooth acceleration
	velocity = velocity.lerp(
		target_vel, delta * acceleration
	)
	animation_player.play("Armature|Running")

	# 6) Smoothly rotate yaw toward movement direction
	var current_yaw = rotation.y
	# Godot’s forward vector is -Z, so angle = atan2(x, -z)
	var desired_yaw = atan2(-world_dir.x, -world_dir.z)
	var new_yaw = lerp_angle(current_yaw, desired_yaw, rotation_speed * delta)
	rotation.y = new_yaw

	# 7) Move
	move_and_slide()
