extends Area3D
@export var trampoline_force := 5.0
@export var audio_jump:AudioStreamPlayer3D
@onready var key: Key = $"../../../castle2/key3"

var _key_out : bool
func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("is character")
		print(body.velocity)
		if body.velocity.y < -1:
			if audio_jump != null: audio_jump.play()
			body.velocity.y = trampoline_force

func _on_body_entered_spawn_key(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("is character")
		print(body.velocity)
		if body.velocity.y < -1:
			if audio_jump != null: audio_jump.play()
			body.velocity.y = trampoline_force
			if _key_out: return
			_key_out = true
			key.visible = true
			key.freeze = false
