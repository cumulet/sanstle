class_name Teleporter
extends Area3D

@export var destination_point: Teleporter
@export var exit_position: Node3D
@export var change_swim : bool

@export var sound_to_stop : Array[CustomAudio]
@export var sound_to_start : Array[CustomAudio]

func teleport(body:Node3D):
	if body is Character:
		if change_swim:
			body._submerged_lock = !body._submerged_lock
		if destination_point == null: return
		body.global_position = destination_point.exit_position.global_position
		
		for to_start in sound_to_start:
			to_start._fade_in()
		for to_stop in sound_to_stop:
			to_stop._fade_out()
