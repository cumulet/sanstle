extends Node3D

const MAIN = "res://gamescenes/start.tscn"

func restart():
	get_tree().change_scene_to_file(MAIN)
	GlobalVar.reset()
