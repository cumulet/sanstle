extends Area3D

const  END_SCENE = "res://gamescenes/end_scene.tscn"
@onready var dungeon_ambiance: CustomAudio = $"../Audio/DungeonAirByFlamiffer"
@onready var fade: ColorRect = $"../ColorRect2"
@onready var music: CustomAudio = $"../Audio/music"

func end_main(body:Node3D):
	fade.fade_out()
	var t  = create_tween()
	t.tween_property(dungeon_ambiance, "volume_linear", 0, 2.0)
	t.tween_property(music, "volume_linear", 0,2.0)
	
	await t.finished
	var bus_idx = AudioServer.get_bus_index("Character")
	AudioServer.set_bus_effect_enabled(bus_idx, 0, false)
	get_tree().change_scene_to_file(END_SCENE)
