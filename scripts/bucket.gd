class_name bucket
extends Pickable

func _physics_process(_delta: float) -> void:
	flotte()

func flotte():
	_submerged = false
	var depth = (water.global_position.y - water_depth_offset) - global_position.y 
	if depth > 0:
		_submerged = true
		
		linear_velocity *=  1 - water_drag
		angular_damp = water_drag*3
		linear_velocity += Vector3.UP *.1 * 9.81 * depth
