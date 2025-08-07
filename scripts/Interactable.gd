class_name Interactable
extends RigidBody3D

@export var water_depth_offset : float
@export var water_drag : float
@export var ui_text : DialogueResource
@onready var water: MeshInstance3D = $"../water"

const BALLOON_UI = preload("uid://d2fftv85mgtvb")

var _submerged : bool
var _dialogue_lock : bool
var _current_baloon_ui : CustomDialogue
var done : bool

@export var closest : bool

func is_closest():
	if !closest:
		closest = true
		if done : return
		show_ui() 

func is_not_closest():
	if closest:
		closest = false
		hide_ui()
		
func interact(parent:Node3D = null):
	hide_ui()

func show_ui():
	_current_baloon_ui = BALLOON_UI.instantiate()
	get_tree().root.add_child(_current_baloon_ui)
	_current_baloon_ui.start(ui_text, "start")

func hide_ui():
	if _current_baloon_ui != null:
		_current_baloon_ui.queue_free()
		_current_baloon_ui = null
