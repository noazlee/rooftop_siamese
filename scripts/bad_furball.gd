extends CharacterBody2D

@export var is_void: bool = false   # check this on your void Area2Ds in the Inspector
@onready var timer: Timer = $Timer
@onready var timer_away: Timer = $TimerAway
@onready var area_2d: Area2D = $Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

const FURBALL_SPEED = 18000.0
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.modulate = Color(1.0, 0.3, 0.3)
	area_2d.monitoring = false
	timer.start()
	timer_away.start()
	await get_tree().process_frame
	await get_tree().process_frame
	area_2d.monitoring = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	velocity.x = direction * FURBALL_SPEED * delta
	move_and_slide()
	

func _on_timer_timeout() -> void:
	queue_free()
	timer.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.has_method("take_damage"):
		return
	var damage = body.MAX_HEALTH if is_void else 1
	body.take_damage(damage)
	queue_free() 
