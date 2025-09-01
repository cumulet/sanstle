class_name Pickable
extends Interactable

@export var picked_wanted_rotation : Vector3
@export var picked_wanted_offset : Vector3

func interact(parent:Node3D = null):
	if _interact_lock: return
	super.interact(parent)
	if parent != null:
		if parent is Character:
			if !parent._holding:
					reparent(parent)
					parent.selected_pickable = self
					parent.take.play()
					freeze = true
					rotation_degrees = picked_wanted_rotation
					position = picked_wanted_offset
					parent._holding = true;
			else :
					reparent(get_tree().get_root().get_node("main"))
					parent.selected_pickable = null
					parent.drop.play()
					linear_velocity = Vector3.ZERO
					parent._holding = false
					parent._interacting = false
					freeze = false
