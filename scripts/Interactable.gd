class_name Interactable
extends RigidBody3D


@export var water_depth_offset : float
@export var water_drag : float
@onready var water: MeshInstance3D = $"../water"

signal is_interacting
signal is_not_interacting
var _submerged : bool
