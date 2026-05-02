extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = $AnimatableBody2D/AnimationPlayer

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	animation_player.play("move")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var wait_time = randf_range(0.5, 4)
	wait(wait_time)
	
