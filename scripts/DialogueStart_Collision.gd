extends Node3D
@export var dialogue_resource: DialogueResource
const BALLOON = preload("res://gamescenes/balloon.tscn")

var _started : bool
var _current_baloon : CustomDialogue

func start_dialogue():
	if _started: return
	_started=true
	_current_baloon = BALLOON.instantiate()
	get_tree().root.add_child(_current_baloon)
	_current_baloon.start(dialogue_resource, "start")

func remove_dialogue():
	if _current_baloon != null:
		_current_baloon.queue_free()
		_current_baloon = null

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		start_dialogue()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		remove_dialogue()
