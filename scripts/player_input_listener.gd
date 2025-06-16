class_name PlayerInputs
extends Node

@export var selected_player: CharacterBody3D
@export var player_index: int = 0

# rotation smoothing speed (in radians/sec)


@onready var camera_3d: Camera3D = $"../Camera3D"

func _process(delta: float) -> void:
	# 1) Read and deadzone the stick
	var x_input = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X)
	var y_input = -Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y)
	if abs(x_input) < 0.1: x_input = 0
	if abs(y_input) < 0.1: y_input = 0
	
	selected_player.character_movement(delta, x_input, y_input)
