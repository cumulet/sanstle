class_name DialogueStart
extends Interactable

@export var dialogue_resource: DialogueResource
const BALLOON = preload("res://gamescenes/balloon.tscn")

var _current_baloon : CustomDialogue
var _dialogue_open : bool
var _current_character : Character

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(remove_dialogue)

func interact(parent:Node3D = null):
	super.interact(parent)
	start_dialogue()

func start_dialogue():
		if _current_baloon != null: return
		if _dialogue_lock: return
		
		_current_baloon = BALLOON.instantiate()
		get_tree().root.add_child(_current_baloon)
		_current_baloon.start(dialogue_resource, "start")

func remove_dialogue(resource: DialogueResource):
	if _current_baloon != null:
		_current_baloon.queue_free()
		_current_baloon = null
		_dialogue_lock = true
		await get_tree().create_timer(.2).timeout
		_dialogue_lock = false
