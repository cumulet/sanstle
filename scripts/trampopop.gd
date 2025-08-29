extends Area3D
@export var trampoline_force := 5.0
@export var audio_jump:AudioStreamPlayer3D
func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("is character")
		print(body.velocity)
		if body.velocity.y < -1:
			audio_jump.play()
			body.velocity.y = trampoline_force
