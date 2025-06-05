extends Node

var player_index = 0
@export var movement_speed := 2
@export var selected_player:Node3D

func _process(delta: float) -> void:
	var x = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X)
	var y = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y)
	
	if x > 0.1 || x < -0.1:
		selected_player.global_position += Vector3.RIGHT*x*delta*movement_speed
		
		
	if y > 0.1 || y < -0.1:
		selected_player.global_position += Vector3.BACK*y*delta*movement_speed
