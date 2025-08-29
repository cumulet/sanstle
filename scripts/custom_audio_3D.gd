class_name CustomAudio3D
extends AudioStreamPlayer3D

@export var fade_start := false
func _ready() -> void:
	if fade_start:
		_play_soft()

func _play_soft():
	volume_linear = 0
	play()
	create_tween().tween_property(self, "volume_linear", .6, 3.0)
