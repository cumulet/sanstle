extends ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	fade_in()
	
func fade_in():
	animation_player.play("fade_in")
	
func fade_out():
	animation_player.play("fade_out")
