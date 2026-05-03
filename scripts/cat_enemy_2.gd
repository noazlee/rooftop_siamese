extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var timer: Timer = $Timer
@onready var shoot_timer: Timer = $ShootTimer
@onready var lick_timer: Timer = $LickTimer
@onready var lick_timer_timer: Timer = $LickTimerTimer
@onready var next_level_timer: Timer = $NextLevelTimer
@onready var die_sfx: AudioStreamPlayer2D = $DieSFX
@onready var shoot_sfx: AudioStreamPlayer2D = $ShootSFX

const FURBALL = preload("uid://j5iiajapi2qr")

var health = 2
const SPEED = 80.0
const JUMP_VELOCITY = -330.0
var direction = 1
var is_licking = false
var alive = true
var will_shoot = false

func take_damage(amount: int) -> void:
	health -= amount
	velocity.y = -90
	die_sfx.play()
	if health <= 0:
		queue_free()

func _ready() -> void:
	ray_cast_left.collision_mask = 2
	ray_cast_right.collision_mask = 2
	animated_sprite_2d.flip_h = true
	timer.wait_time = randf_range(2.0, 6.0)
	shoot_timer.wait_time = randf_range(1.0, 4.0)
	shoot_timer.start()
	timer.start()
	lick_timer.start()
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
			
	if is_licking or not alive:
		return
		
	if is_on_floor():
		
		if ray_cast_left.is_colliding() or ray_cast_right.is_colliding():
			will_shoot = true
		
		if ray_cast_left.is_colliding() or not ray_cast_down_right.is_colliding():
			animated_sprite_2d.flip_h = true
			direction = -1
			
		if ray_cast_right.is_colliding() or not ray_cast_down_left.is_colliding():
			animated_sprite_2d.flip_h = false
			direction = 1
	
		
	position.x += direction * SPEED * delta
		
	move_and_slide()


func _on_timer_timeout() -> void:
	if alive and ray_cast_down_left.is_colliding() and ray_cast_down_right.is_colliding():
		timer.wait_time = randf_range(1.0, 5.0)
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

func _on_shoot_timer_timeout() -> void:
	shoot()
	shoot_timer.start(randf_range(2.0, 4.5))
	
	
func shoot():
	if alive and will_shoot:
		shoot_sfx.play()
		var furball = FURBALL.instantiate()
		get_tree().root.add_child(furball)  # add to scene FIRST
		
		add_collision_exception_with(furball)  # enemy ignores furball
		# Ignore ALL cat enemies
		for enemy in get_tree().get_nodes_in_group("cat_enemy"):
			furball.add_collision_exception_with(enemy)
		
		furball.position = Vector2(position.x, position.y - 10)
		furball.direction = direction


func _on_lick_timer_timeout() -> void:
	if not is_licking and is_on_floor():
		is_licking = true
		velocity.x = 0
		animated_sprite_2d.play("lick")
		lick_timer_timer.start()


func _on_lick_timer_timer_timeout() -> void:
	is_licking = false
	animated_sprite_2d.play("idle")
	lick_timer_timer.stop()
	lick_timer.start(randf_range(2.0, 7.5))
