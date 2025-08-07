class_name Pickable
extends Interactable

func interact(parent:Node3D = null):
	if parent != null:
		if parent is Character:
			if !parent._holding:
					reparent(parent)
					position = parent.grabbed_object_offset
					parent._holding = true;
			else :
					reparent(get_tree().get_root())
					linear_velocity = Vector3.ZERO
					parent._holding = false
					parent._interacting = false
