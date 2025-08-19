class_name Brazier
extends Interactable
@onready var succeed_fire: PondTest = $"../SucceedFire"

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Interactable:
		if body.flammable && flammable:
			if !body.ignited:
				if ignited:
					body._ignite()
			else:
				if !ignited:
					_ignite()
		

func _ignite():
	super._ignite()
	succeed_fire.update_ponds()
