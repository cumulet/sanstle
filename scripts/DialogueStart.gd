class_name DialogueStart
extends Interactable

@export var dialogue_resource: DialogueResource
@onready var dialogue_baloon: CustomDialogue = $"../dialogue_baloon"
const BALLOON = preload("res://gamescenes/balloon.tscn")

var _current_baloon : CustomDialogue
var _dialogue_open : bool
var _dialogue_lock_end : bool

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_end)

func start_dialogue():
	is_interacting.emit()
	if !_dialogue_open && !_dialogue_lock_end:
		_dialogue_open = true
		remove_dialogue()
		_current_baloon = BALLOON.instantiate()
		get_tree().root.add_child(_current_baloon)
		_current_baloon.start(dialogue_resource, "start")

func _on_dialogue_end(resource:DialogueResource):
	is_not_interacting.emit()
	_dialogue_lock_end = true
	_dialogue_open = false
	await get_tree().create_timer(.2).timeout
	_dialogue_lock_end = false
	
func remove_dialogue():
	if _current_baloon != null:
		_current_baloon.queue_free()
		_current_baloon = null
