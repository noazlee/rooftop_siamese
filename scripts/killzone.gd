extends Area2D

@export var is_void: bool = false   # check this on your void Area2Ds in the Inspector

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("take_damage"):
		return
	var damage = body.MAX_HEALTH if is_void else 1
	body.take_damage(damage)
	if body.health <= 0:
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	timer.stop()
