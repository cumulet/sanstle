class_name PlayerBehaviour
extends CharacterBody3D

@export var is_selected: bool
@export var movement_speed := 2.0
@export var acceleration := 2.0
@export var friction := 2.0
@export var jump_force := 4.0
@export var rotation_speed := 15.0
@export var water_drag := 0.05
@export var water_depth_offset := .2
@onready var animation_player: AnimationPlayer = $character/AnimationPlayer
@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var water: MeshInstance3D = $"../water"

@onready var watersplash: CPUParticles3D = $vfx/watersplash

@export var pickables : Array[Pickable] 
@export var selected_pickable : Pickable

var _submerged : bool
var _isJumping : bool

func addObject(body:Node3D):
	if body is Pickable:
		pickables.append(body)

func removeObject(body:Node3D):
	if body is Pickable:
		pickables.remove_at(pickables.find(body))

func _process(_delta: float) -> void:
	get_closest_pickable() 

func _physics_process(_delta):
	_submerged = false
	var depth = (water.global_position.y - water_depth_offset) - global_position.y 
	if depth > 0:
		if velocity.y < -5 : watersplash.emitting = true
		
		_submerged = true
		velocity *=  1 - water_drag
		velocity += Vector3.UP *.1 * 9.81 * depth
		
func get_closest_pickable(max_angle: float = 45.0) -> Pickable:
	if pickables.is_empty():
		return null

	var closest: Pickable = null
	var closest_dist := INF

	# Forward direction (ignoring Y so the cone stays horizontal)
	var forward = -global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()

	for p in pickables:
		if not is_instance_valid(p):
			continue

		var to_pickable = (p.global_position - global_position)
		to_pickable.y = 0 # ignore vertical offset for angle
		to_pickable = to_pickable.normalized()

		# Calculate angle between forward and the vector to the pickable
		var angle_deg = rad_to_deg(forward.angle_to(to_pickable))

		if angle_deg <= max_angle:
			var dist = global_position.distance_to(p.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest = p

	return closest
	
func character_movement(delta:float,x_input:float, y_input:float, jump_input:float, take_input:float):
	velocity.y -= 9.81 * delta
	if jump_input != 0:
		if is_on_floor(): 
			_isJumping = true
			animation_player.play("Jump")
	
	if _isJumping && velocity.y < -0.2:
		_isJumping = false
		
	if x_input == 0 and y_input == 0:
		# slow down
		velocity = velocity.lerp(
			Vector3(0,velocity.y,0), delta * friction
		)
		if(!_isJumping):animation_player.play("Idle")
		move_and_slide()
		return
	
	if take_input>0.1 :
		#take_object()
		pass
		

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
	var target_vel_gravity = Vector3(target_vel.x, velocity.y, target_vel.z)
	# smooth acceleration
	velocity = velocity.lerp(
		target_vel_gravity, delta * acceleration
	)
	if(!_isJumping):
		if _submerged:
			animation_player.play("Swimming")
		else:
			animation_player.play("Running")

	# 6) Smoothly rotate yaw toward movement direction
	var current_yaw = rotation.y
	# Godot’s forward vector is -Z, so angle = atan2(x, -z)
	var desired_yaw = atan2(-world_dir.x, -world_dir.z)
	var new_yaw = lerp_angle(current_yaw, desired_yaw, rotation_speed * delta)
	rotation.y = new_yaw

	# 7) Move
	move_and_slide()

func _jump() -> void:
	velocity.y += jump_force 

func take_object(pick:Pickable):
	pick.global_position = global_position + Vector3(0,1,2)
	
