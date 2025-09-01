extends RigidBody3D

var is_in_screen : bool
func set_screen_presence(value:bool):
	is_in_screen = value
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interract"):
		var dir : Vector3
		if is_in_screen:
			dir = Vector3(randf_range(0,1), randf_range(0,1), 0) * randf_range(1,10)
			
		else:
			dir = (Vector3.ZERO - global_position) * randf_range(.3,.6)
			
		linear_velocity = dir
		angular_velocity = Vector3(randf_range(1,10), randf_range(1,10), randf_range(1,10))
