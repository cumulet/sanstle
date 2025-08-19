class_name Teleporter
extends Area3D

@export var destination_point: Teleporter
@export var exit_position: Node3D

func teleport(body:Node3D):
	if body is Character:
		if destination_point == null: return
		body.global_position = destination_point.exit_position.global_position
