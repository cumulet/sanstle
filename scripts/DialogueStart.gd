class_name DialogueStart
extends Interactable

@export var dialogue_resource: DialogueResource
@onready var dialogue_baloon: CustomDialogue = $"../dialogue_baloon"
const BALLOON = preload("res://gamescenes/balloon.tscn")

var _current_baloon : CustomDialogue

func start_dialogue():
	_current_baloon = BALLOON.instantiate()
	get_tree().root.add_child(_current_baloon)
	_current_baloon.start(dialogue_resource, "start")

func remove_dialogue():
	if _current_baloon != null:
		_current_baloon.queue_free()
		_current_baloon = null
