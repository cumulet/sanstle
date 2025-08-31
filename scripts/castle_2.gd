extends Node3D

var is_key_1_inserted: bool = false
var is_key_2_inserted: bool = false
var is_key_animation_playing: bool = false

@onready var key_detection_area_1: Area3D = $KeyDetectionArea1
@onready var key_detection_area_2: Area3D = $KeyDetectionArea2
@onready var key_marker_1: Marker3D = $KeyMarker1
@onready var left_key_marker: Marker3D = $LeftKeyMarker
@onready var key_marker_2: Marker3D = $KeyMarker2
@onready var right_key_marker: Marker3D = $RightKeyMarker
@onready var char_1: Character = $"../char1"
@onready var door_1: MeshInstance3D = $castle2_inside/castle_model/Door1
@onready var door_2: MeshInstance3D = $castle2_inside/castle_model/Door2


func open_door() -> void:
	var door_tween: Tween = create_tween()
	door_tween.tween_property(door_1, 'global_rotation_degrees', Vector3(0, -190, 0), 2.0).set_trans(Tween.TRANS_SINE)
	door_tween.set_parallel()
	door_tween.tween_property(door_2, 'global_rotation_degrees', Vector3(0, 10, 0), 2.0).set_trans(Tween.TRANS_SINE)


func update_door() -> void:
	if is_key_1_inserted and is_key_2_inserted:
		open_door()


func _on_key_detection_area_1_body_entered(body: Node3D) -> void:
	if body is Key:
		if is_key_animation_playing:
			return
		is_key_animation_playing = true
		key_detection_area_1.queue_free()
		body.interact(char_1)
		body.freeze = true
		var key_tween: Tween = create_tween().set_parallel(true)
		key_tween.tween_property(body, "global_position", key_marker_1.global_position, 2.0).set_trans(Tween.TRANS_SINE)
		key_tween.tween_property(body, "global_basis", key_marker_1.global_basis, 2.0).set_trans(Tween.TRANS_SINE)
		key_tween.chain().tween_property(body, "global_position", left_key_marker.global_position, 1.0).set_trans(Tween.TRANS_SINE)
		key_tween.tween_property(body, "global_basis", left_key_marker.global_basis, 1.0).set_trans(Tween.TRANS_SINE)
		await key_tween.finished
		is_key_1_inserted = true
		update_door()
		is_key_animation_playing = false
		body.set_script(null)


func _on_key_detection_area_2_body_entered(body: Node3D) -> void:
	if body is Key:
		if is_key_animation_playing:
			return
		is_key_animation_playing = true
		key_detection_area_2.queue_free()
		body.interact(char_1)
		body.freeze = true
		var key_tween: Tween = create_tween().set_parallel(true)
		key_tween.tween_property(body, "global_position", key_marker_2.global_position, 2.0).set_trans(Tween.TRANS_SINE)
		key_tween.tween_property(body, "global_basis", key_marker_2.global_basis, 2.0).set_trans(Tween.TRANS_SINE)
		key_tween.chain().tween_property(body, "global_position", right_key_marker.global_position, 1.0).set_trans(Tween.TRANS_SINE)
		key_tween.tween_property(body, "global_basis", right_key_marker.global_basis, 1.0).set_trans(Tween.TRANS_SINE)
		await key_tween.finished
		is_key_2_inserted = true
		update_door()
		is_key_animation_playing = false
		body.set_script(null)
