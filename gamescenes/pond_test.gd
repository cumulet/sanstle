class_name PondTest
extends Node3D

@export var rock_animationplayers : Array[AnimationPlayer]
var current_activated_ponds := 0
var max_amount_ponds := 3

func update_ponds():
	current_activated_ponds += 1
	if current_activated_ponds >= max_amount_ponds:
		succeed_pond_test()

func succeed_pond_test():
	for a in rock_animationplayers:
		a.play("rock")
