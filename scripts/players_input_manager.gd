extends Node3D



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("join"):
		print(event.device)
		print(Input.get_connected_joypads())
		print(Input.get_joy_name(event.device))
