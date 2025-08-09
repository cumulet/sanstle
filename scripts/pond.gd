class_name Pond
extends Interactable

@export var particles : Array[CPUParticles3D]
@export var pond_manager : PondTest
func interact(parent:Node3D = null):
	done = true
	super.interact(parent)
	pond_manager.update_ponds()
	for p in particles:
		p.emitting = true;
