extends CharacterBody2D

@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer_away: Timer = $TimerAway

const FURBALL_SPEED = 18000.0
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	timer_away.start()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	velocity.x = direction * FURBALL_SPEED * delta
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()


#func _on_timer_away_timeout() -> void:
	#print("off")
	#collision_shape_2d.disabled = false
	#timer_away.stop()
