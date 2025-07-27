class_name PlayersManager
extends Node3D

@export var BodyToIncarnate: Array[PlayerBehaviour]
@export var JoinedPlayers: Array[PlayerInputs]

var scene_to_instance = preload("res://gamescenes/player.tscn")

func instance_object(index:int):
	if JoinedPlayers.get(index) != null: return
	var object:PlayerInputs = scene_to_instance.instantiate()
	JoinedPlayers.append(object)
	call_deferred("add_child",object)
	
	if object is PlayerInputs:
		# Find the first unselected player
		for body in BodyToIncarnate:
			if not body.is_selected:
				object.player_index = index
				object.selected_player = body
				body.is_selected = true
				break
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("join"):
		instance_object(event.device)
		print(event.device)
		print(Input.get_connected_joypads())
		print(Input.get_joy_name(event.device))
