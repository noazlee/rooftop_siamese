extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var timer: Timer = $Timer

const SPEED = 50.0
const JUMP_VELOCITY = -270.0
var direction = 1

func _ready() -> void:
	animated_sprite_2d.flip_h = true
	timer.wait_time = randf_range(2.0, 6.0)
	timer.start()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		
		if ray_cast_right.is_colliding() or not ray_cast_down_right.is_colliding():
			animated_sprite_2d.flip_h = false
			direction = -1
			
		if ray_cast_left.is_colliding() or not ray_cast_down_left.is_colliding():
			animated_sprite_2d.flip_h = true
			direction = 1
	
		
	position.x += direction * SPEED * delta
		
	move_and_slide()


func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(1.0, 5.0)
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
