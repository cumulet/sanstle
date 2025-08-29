class_name Pickable
extends Interactable

@export var picked_wanted_rotation : Vector3

func interact(parent:Node3D = null):
	super.interact(parent)
	if parent != null:
		if parent is Character:
			if !parent._holding:
					reparent(parent)
					parent.take.play()
					freeze = true
					rotation_degrees = picked_wanted_rotation
					position = parent.grabbed_object_offset
					parent._holding = true;
			else :
					reparent(get_tree().get_root())
					parent.drop.play()
					linear_velocity = Vector3.ZERO
					parent._holding = false
					parent._interacting = false
					freeze = false
