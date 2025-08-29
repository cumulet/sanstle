extends Node3D

signal animation_event
signal footstep
signal swim

func _emit_animation_event():
	animation_event.emit()

func footsteps():
	footstep.emit()
	
func swimming():
	swim.emit()
