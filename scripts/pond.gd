class_name Pond
extends Interactable

@export var particles : Array[CPUParticles3D]
func interact(parent:Node3D = null):
	done = true
	super.interact(parent)
	for p in particles:
		p.emitting = true;
