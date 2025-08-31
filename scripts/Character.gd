class_name Character
extends CharacterBody3D

@export var is_selected: bool
@export var movement_speed := 2.0
@export var acceleration := 2.0
@export var friction := 2.0
@export var jump_force := 4.0
@export var rotation_speed := 15.0
@export var water_drag := 0.05
@export var water_depth_offset := .2
@export var water: MeshInstance3D
@onready var animation_player: AnimationPlayer = $character/AnimationPlayer
@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var footsteps_sand: AudioStreamPlayer3D = $footsteps_sand
@onready var footsteps_wood: AudioStreamPlayer3D = $footsteps_wood
@onready var footsteps_water: AudioStreamPlayer3D = $footsteps_water
@onready var footsteps_stone: AudioStreamPlayer3D = $footsteps_stone
@onready var jump: AudioStreamPlayer3D = $jump
@onready var swim: AudioStreamPlayer3D = $swim
@onready var take: AudioStreamPlayer3D = $take
@onready var drop: AudioStreamPlayer3D = $drop
@onready var ray_cast_3d: RayCast3D = $RayCast3D

@export var interactables : Array[Interactable] 
var previous_closest_interactable: Interactable = null
var closest_interactable : Interactable
var selected_pickable : Interactable

var _submerged_lock : bool
var _submerged : bool
var _isJumping : bool
var _holding : bool
var _interacting : bool

var last_jump_input := 0

signal watersplash


func addObject(body:Node3D):
	if body is Interactable:
		interactables.append(body)


func removeObject(body:Node3D):
	if body is Interactable:
		interactables.remove_at(interactables.find(body))


func _process(_delta: float) -> void:
	closest_interactable = get_closest_interactable()
	
	if closest_interactable != null:
		if !_interacting:
			closest_interactable.is_closest()
	
	if closest_interactable == null && previous_closest_interactable != null:
		previous_closest_interactable.is_not_closest()
	if previous_closest_interactable != null && previous_closest_interactable != closest_interactable:
		previous_closest_interactable.is_not_closest()
	
	previous_closest_interactable = closest_interactable


func _physics_process(_delta):
	if _submerged_lock : return
	flotte()


func flotte():
	_submerged = false
	if water == null: return
	var depth = (water.global_position.y - water_depth_offset) - global_position.y 
	if depth > 0:
		if velocity.y < -5 : watersplash.emit()
		_submerged = true
		velocity *=  1 - water_drag
		velocity += Vector3.UP *.1 * 9.81 * depth


func get_closest_interactable(max_angle: float = 90.0) -> Interactable:
	if interactables.is_empty():
		return null
	
	var closest: Interactable = null
	var closest_dist := INF

	# Forward direction (ignoring Y so the cone stays horizontal)
	var forward = -global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()

	for i in interactables:
		if not is_instance_valid(i):
			continue

		var to_interactable = (i.global_position - global_position)
		to_interactable.y = 0 # ignore vertical offset for angle
		to_interactable = to_interactable.normalized()

		# Calculate angle between forward and the vector to the interactable
		var angle_deg = rad_to_deg(forward.angle_to(to_interactable))

		if angle_deg <= max_angle:
			var dist = global_position.distance_to(i.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest = i

	return closest


func character_proces(delta:float,x_input:float, y_input:float, jump_input:float, take_input:float):
	velocity.y -= 9.81 * delta
	
	if jump_input != 0 && last_jump_input == 0:
		last_jump_input = 1
		print("1")
		if is_on_floor() && !_isJumping:
			_isJumping = true
			animation_player.play("Jump")
			get_tree().create_timer(0.1677).timeout.connect(_jump)
	elif jump_input == 0 && last_jump_input == 1:
		last_jump_input = 0
		print("0")
	
	if _isJumping && velocity.y < -0.2:
		_isJumping = false
	
	if take_input>0.1:
		interact()
	else:
		_interacting_end()
		
	if x_input == 0 and y_input == 0:
		# slow down
		velocity = velocity.lerp(
			Vector3(0,velocity.y,0), delta * friction
		)
		if(!_isJumping):animation_player.play("Idle")
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
	var target_vel_gravity = Vector3(target_vel.x, velocity.y, target_vel.z)
	# smooth acceleration
	velocity = velocity.lerp(
		target_vel_gravity, delta * acceleration
	)
	if(!_isJumping):
		if _submerged:
			animation_player.play("Swimming")
		else:
			if velocity.y < -1 || velocity.y > 1:
				animation_player.play("Idle")
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
	jump.play()
	velocity.y += jump_force


func interact():
	if closest_interactable != null:
		_interacting = true
		closest_interactable.interact(self)


func _interacting_end():
	if _holding: return
	_interacting = false


func play_footstep():
	var col = ray_cast_3d.get_collider()
	if col == null: return
	if col.is_in_group("sand"):
		footsteps_sand.pitch_scale = randf_range(0.8, 1.2)
		footsteps_sand.play()
		return
		
	if col.is_in_group("wood"):
		footsteps_wood.pitch_scale = randf_range(0.8, 1.2)
		footsteps_wood.play()
		return
		
	if col.is_in_group("water"):
		footsteps_water.pitch_scale = randf_range(0.8, 1.2)
		footsteps_water.play()
		return
	
	if col.is_in_group("stone"):
		footsteps_stone.pitch_scale = randf_range(0.8, 1.2)
		footsteps_stone.play()
		return

	footsteps_sand.pitch_scale = randf_range(0.8, 1.2)
	footsteps_sand.play()


func play_swim():
	swim.pitch_scale = randf_range(0.8, 1.2)
	swim.play()
