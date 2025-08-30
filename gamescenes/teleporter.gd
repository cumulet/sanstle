class_name Teleporter
extends Area3D

@export var destination_point: Teleporter
@export var exit_position: Node3D
@export var change_swim : bool
@export var change_reverb: bool
@export var wanterd_reverb : bool
@export var sound_to_stop : Array[CustomAudio]
@export var sound_to_start : Array[CustomAudio]

var character_audio_bus : AudioBusLayout
func teleport(body:Node3D):
	if body is Character:
		if change_swim:
			if body.selected_pickable != null:
					body.selected_pickable.can_float = !body.selected_pickable.can_float 
			body._submerged_lock = !body._submerged_lock
		if destination_point == null: return
		body.global_position = destination_point.exit_position.global_position
		if change_reverb:
			var bus_idx = AudioServer.get_bus_index("Character")
			AudioServer.set_bus_effect_enabled(bus_idx, 0, wanterd_reverb)
		for to_start in sound_to_start:
			to_start._fade_in()
		for to_stop in sound_to_stop:
			to_stop._fade_out()
