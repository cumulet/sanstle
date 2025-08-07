class_name Interactable
extends RigidBody3D

@export var water_depth_offset : float
@export var water_drag : float
@export var ui_text : DialogueResource
@onready var water: MeshInstance3D = $"../water"

const BALLOON_UI = preload("uid://d2fftv85mgtvb")

signal is_interacting
signal is_not_interacting
var _submerged : bool
var _current_baloon_ui : CustomDialogue

func interact(parent:Node3D = null):
	hide_ui()

func show_ui():
	start_dialogue()

func hide_ui():
	remove_dialogue()

func start_dialogue():
		remove_dialogue()
		_current_baloon_ui = BALLOON_UI.instantiate()
		get_tree().root.add_child(_current_baloon_ui)
		_current_baloon_ui.start(ui_text, "start")

func remove_dialogue():
	if _current_baloon_ui != null:
		_current_baloon_ui.queue_free()
		_current_baloon_ui = null
