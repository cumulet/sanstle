class_name Interactable
extends RigidBody3D

@export var water_depth_offset : float
@export var water_drag : float
@export var ui_text : DialogueResource
@export var flammable:bool
@export var fire : Array[Node3D]
@export var ignited : bool 
@export var closest : bool
@export var water: MeshInstance3D
@export var can_float: bool = true

const BALLOON_UI = preload("uid://d2fftv85mgtvb")

var _submerged : bool
var _dialogue_lock : bool
var _current_baloon_ui : CustomDialogue
var done : bool
var fire_is_out: bool
var _interact_lock:=false

func _ready() -> void:
	if ignited:
		_ignite()
	else:
		_fire_out()
		
func _physics_process(_delta: float) -> void:
	if can_float : flotte()

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
	if GlobalVar.interacting: return
	if _interact_lock: return
	if ui_text == null:return
	_current_baloon_ui = BALLOON_UI.instantiate()
	get_tree().root.add_child(_current_baloon_ui)
	_current_baloon_ui.start(ui_text, "start")

func hide_ui():
	if _current_baloon_ui != null:
		_current_baloon_ui.queue_free()
		_current_baloon_ui = null

func _ignite():
	if fire.size() <= 0: return
	ignited = true
	fire_is_out = false
	for p in fire:
		if p is CPUParticles3D:
			p.visible = true
			p.emitting = true
		else:
			p.visible = true

func _fire_out():
	if fire.size() <= 0: return
	if fire_is_out: return;
	fire_is_out = true
	ignited = false
	for p in fire:
		if p is CPUParticles3D:
			p.visible = false
			p.emitting = false
		elif p is AudioStreamPlayer3D:
			p.play()
		else:
			p.visible = false

func flotte():
	if water == null : return
	_submerged = false
	var depth = (water.global_position.y - water_depth_offset) - global_position.y 
	if depth > 0:
		_submerged = true
		_fire_out()
		linear_velocity *=  1 - water_drag
		angular_damp = water_drag*3
		linear_velocity += Vector3.UP *.1 * 9.81 * depth
