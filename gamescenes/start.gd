extends Node3D
const MAIN = "res://gamescenes/main.tscn"

@onready var animation_player: AnimationPlayer = $Control/ColorRect2/AnimationPlayer
@onready var airplane_seatbelt_sign_beep: AudioStreamPlayer = $Node3D/AirplaneSeatbeltSignBeep
@onready var airplane_ambiance: AudioStreamPlayer = $Node3D/AirplaneAmbiance

var launched := false
var _can_start := false

func _ready() -> void:
	animation_player.play("fade_in")
	
func enable_start():
	_can_start = true
	
func _input(event: InputEvent) -> void:
	if !_can_start: return
	if launched: return
		
	if (event is InputEventKey || event is InputEventJoypadButton || event is InputEventMouseButton):
		airplane_seatbelt_sign_beep.play()
		launched = true
		animation_player.play("fade_out")
		create_tween().tween_property(airplane_ambiance, "volume_linear", 0, 2.0)
		
func load_main():
	get_tree().change_scene_to_file(MAIN)
