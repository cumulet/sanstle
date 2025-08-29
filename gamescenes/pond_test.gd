class_name PondTest
extends Node3D

@export var rock_animationplayers : Array[AnimationPlayer]
@export var pond_steam_particles : Array[CPUParticles3D]

@onready var hot_spring: AudioStreamPlayer3D = $"../../Audio/hot_spring"
@onready var win: AudioStreamPlayer3D = $"../../Audio/win"

var current_activated_ponds := 0
var max_amount_ponds := 3

func update_ponds():
	current_activated_ponds += 1
	if current_activated_ponds >= max_amount_ponds:
		succeed_pond_test()

func succeed_pond_test():
	(hot_spring as CustomAudio3D)._play_soft()
	(win as CustomAudio3D)._play_soft()
	for p in pond_steam_particles:
		p.emitting = true
		
	for a in rock_animationplayers:
		a.play("rock")
