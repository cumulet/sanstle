extends Node3D
const MAIN = "res://gamescenes/main.tscn"

@onready var animation_player: AnimationPlayer = $Control/ColorRect2/AnimationPlayer

@onready var airplane_seatbelt_sign_beep: AudioStreamPlayer = $Node3D/AirplaneSeatbeltSignBeep
@onready var airplane_ambiance: AudioStreamPlayer = $Node3D/AirplaneAmbiance
func _ready() -> void:
	animation_player.play("fade_in")
	
func _input(event: InputEvent) -> void:
	if (event is InputEventKey || event is InputEventJoypadButton):
		airplane_seatbelt_sign_beep.play()
		animation_player.play("fade_out")
		create_tween().tween_property(airplane_ambiance, "volume_linear", 0, 2.0)
		
func load_main():
	get_tree().change_scene_to_file(MAIN)
