class_name Brazier
extends Interactable
@export var succeed_fire: PondTest

@onready var fire_sound: AudioStreamPlayer3D = $Fire
@onready var ignition_sound: AudioStreamPlayer3D = $Ignition


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Interactable:
		if body.flammable && flammable:
			if !body.ignited && !ignited: return
			if body.ignited && ignited: return
			if ignition_sound != null: ignition_sound.play()
			if !body.ignited:
				if ignited:
					body._ignite()
			else:
				if !ignited:
					_ignite()
		

func _ignite():
	super._ignite()
	
	fire_sound.play()
	if succeed_fire == null: return
	succeed_fire.update_ponds()
