class_name CustomAudio
extends AudioStreamPlayer
@export var fade_start := false

func _ready() -> void:
	if fade_start:
		_fade_in()

func _fade_in():
	play()
	volume_linear = 0
	create_tween().tween_property(self, "volume_linear", .6, 3.0)

func _fade_out():
	create_tween().tween_property(self, "volume_linear", 0, 3.0)
