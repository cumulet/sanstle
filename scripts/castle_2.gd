extends Node3D

@onready var door_1: MeshInstance3D = $castle2_inside/castle_model/Door1
@onready var door_2: MeshInstance3D = $castle2_inside/castle_model/Door2
@onready var music: AudioStreamPlayer = $"../Audio/music"
@onready var phantom_camera_3d_end: PhantomCamera3D = $"../PhantomCamera3D_end"

var keyhole_unlocked := 0

func open_door() -> void:	
	music._fade_in()
	phantom_camera_3d_end.priority = 2
	var door_tween: Tween = create_tween()
	door_tween.tween_property(door_1, 'global_rotation_degrees', Vector3(0, -190, 0), 2.0).set_trans(Tween.TRANS_SINE)
	door_tween.set_parallel()
	door_tween.tween_property(door_2, 'global_rotation_degrees', Vector3(0, 10, 0), 2.0).set_trans(Tween.TRANS_SINE)


func update_door() -> void:
	keyhole_unlocked+=1 
	if keyhole_unlocked >= 2 :
		open_door()
