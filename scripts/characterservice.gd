extends Node3D

signal animation_event

func _emit_animation_event():
	emit_signal("animation_event")
