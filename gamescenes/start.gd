extends Node3D
const MAIN = "res://gamescenes/main.tscn"
func _input(event: InputEvent) -> void:
	if (event is InputEventKey || event is InputEventJoypadButton):
		get_tree().change_scene_to_file(MAIN)
