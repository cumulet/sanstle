extends Area3D
@onready var model_: Node3D = $"../model"
@onready var static_sandcastle: Node3D = $".."
@onready var vfx: CPUParticles3D = $"../poofing"
@onready var sand_audio: AudioStreamPlayer3D = $"../sand"
@onready var destroy: AudioStreamPlayer3D = $"../destroy"


var amount_jumps_before_destroy := 3
var current_jumps := 0

signal castle_destroyed 
func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if body.velocity.y < -1:
			sand_audio.pitch_scale = randf_range(.8,1.1)
			sand_audio.play()
			current_jumps +=1
			model_.scale *= Vector3(1,.8,1)
			if current_jumps >= amount_jumps_before_destroy:
				_destroy_castle()

func _destroy_castle():
	castle_destroyed.emit()
	vfx.emitting = true
	destroy.play()
	model_.queue_free()
	queue_free()
	
