class_name PlayerInputs
extends Node

@export var selected_player: CharacterBody3D
@export var player_index: int = 0

@onready var camera_3d: Camera3D = $"../Camera3D"

func _process(delta: float) -> void:
	
	if selected_player == null: return
	if Input.get_connected_joypads().size() != 0:
		# 1) Read and deadzone the stick
		var x_input = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X)
		var y_input = -Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y)
		if abs(x_input) < 0.1: x_input = 0
		if abs(y_input) < 0.1: y_input = 0
		
		var jump_input = Input.is_joy_button_pressed(player_index, JOY_BUTTON_A)
		var take_input = Input.is_joy_button_pressed(player_index, JOY_BUTTON_B)

		selected_player.character_movement(delta, x_input, y_input, jump_input, take_input)
	else:
		var x_input_pos = 1 if Input.is_key_pressed(KEY_D) else 0
		var x_input_neg = -1 if Input.is_key_pressed(KEY_Q) else 0
		var y_input_pos = 1 if Input.is_key_pressed(KEY_Z) else 0
		var y_input_neg = -1 if Input.is_key_pressed(KEY_S) else 0
		var x_input = x_input_pos + x_input_neg
		var y_input = y_input_pos + y_input_neg
		
		if abs(x_input) < 0.1: x_input = 0
		if abs(y_input) < 0.1: y_input = 0
		
		var jump_input = Input.is_key_pressed(KEY_SPACE)
		var take_input = Input.is_key_pressed(KEY_E)

		selected_player.character_movement(delta, x_input, y_input, jump_input, take_input)
