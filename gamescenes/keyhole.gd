extends Area3D

var is_key_animation_playing: bool = false
var is_key_inserted : bool
@onready var character: Character = $"../../char1"
@onready var castle: Node3D = $".."

@export var key_marker : Node3D
@export var vfx : CPUParticles3D
@export var audio : AudioStreamPlayer3D

func _on_key_body_entered(body: Node3D) -> void:
	if body is Key:
		if is_key_animation_playing:
			return
		is_key_animation_playing = true
		monitoring = false
		monitorable = false
		body.interact(character)
		body._interact_lock = true
		body.freeze = true
		var key_tween: Tween = create_tween().set_parallel(true)
		key_tween.tween_property(body, "global_position", key_marker.global_position, 2.0)
		key_tween.tween_property(body, "global_rotation", key_marker.global_rotation, 2.0)
		key_tween.chain().tween_property(body,"global_rotation_degrees", Vector3(0,90,90), 1.0)
		await key_tween.finished
		if vfx != null: vfx.emitting = true
		if audio != null: audio.play()
		is_key_inserted = true
		castle.update_door()
		is_key_animation_playing = false
		body._interact_lock = true
