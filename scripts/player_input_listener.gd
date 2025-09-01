class_name PlayerInputs
extends Node

@export var selected_player: CharacterBody3D
@export var player_index: int = 0

enum INPUT_METHOD {
	KEYBOARD,
	CONTROLLER
}
var current_input_method := INPUT_METHOD.KEYBOARD

@onready var camera_3d: Camera3D = $"../Camera3D"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		current_input_method = INPUT_METHOD.CONTROLLER
	else:
		current_input_method = INPUT_METHOD.KEYBOARD


func _process(delta: float) -> void:
	
	if selected_player == null: return
	
	match current_input_method:
		INPUT_METHOD.CONTROLLER:
			# 1) Read and deadzone the stick
			var x_input = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X)
			var y_input = -Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y)
			if abs(x_input) < 0.1: x_input = 0
			if abs(y_input) < 0.1: y_input = 0
			
			var jump_input = Input.is_joy_button_pressed(player_index, JOY_BUTTON_A)
			var take_input = Input.is_joy_button_pressed(player_index, JOY_BUTTON_B)

			selected_player.character_proces(delta, x_input, y_input, jump_input, take_input)
		INPUT_METHOD.KEYBOARD:
			var x_input_pos = 1 if Input.is_physical_key_pressed(KEY_D) else 0
			var x_input_neg = -1 if Input.is_physical_key_pressed(KEY_A) else 0
			var y_input_pos = 1 if Input.is_physical_key_pressed(KEY_W) else 0
			var y_input_neg = -1 if Input.is_physical_key_pressed(KEY_S) else 0
			var x_input = x_input_pos + x_input_neg
			var y_input = y_input_pos + y_input_neg
			
			if abs(x_input) < 0.1: x_input = 0
			if abs(y_input) < 0.1: y_input = 0
			
			var jump_input = Input.is_key_pressed(KEY_SPACE)
			var take_input = Input.is_action_just_pressed("interract")
			selected_player.character_proces(delta, x_input, y_input, jump_input, take_input)
