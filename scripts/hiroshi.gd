extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timers/Timer
@onready var timer_2: Timer = $Timers/Timer2
@onready var timer_3: Timer = $Timers/Timer3
@onready var lick_timer: Timer = $Timers/LickTimer
@onready var jump_timer: Timer = $Timers/JumpTimer
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var small_wall_timer: Timer = $Timers/SmallWallTimer
@onready var furball_label: Label = $Camera2D/CanvasLayer/FurballLabel


const FURBALL = preload("uid://egndadgba3hd")
const MAX_FURBALLS = 3
var cur_furballs = 3
var is_licking = false

const WALL_TIME = 2
const WALL_RUN_SPEED = -100.0
const SPEED = 150.0
const JUMP_VELOCITY = -380.0
const MAX_JUMP_TIME = 0.5
var hold_time = 0.0
#var move_limit = 0.3
var move_limit=1.0
var player_rotation = 0
var on_left_wall = false
var on_right_wall = false
var direction_facing = 1

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#timer.start()
	#timer_2.start()
	#timer_3.start()
	pass
	
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("lick"):
		if not is_licking and is_on_floor() and cur_furballs < MAX_FURBALLS :
			print("licking..")
			is_licking = true
			lick_timer.start()
			velocity.x = 0
			animated_sprite_2d.play("lick")
			
	if is_licking:
		return
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Handle spit attack.
	if Input.is_action_just_pressed("spit"):
		if cur_furballs > 0:
			shoot(direction_facing)
			
	
		
	
	# Check if colliding with wall in midair
	if not on_left_wall and ray_cast_left.is_colliding() and not is_on_floor() and direction == -1:
		player_rotation = -80.1
		on_left_wall = true
		jump_timer.start()
		#print("Can walk on wall (left)!")
	elif not on_right_wall and ray_cast_right.is_colliding() and not is_on_floor() and direction == 1:
		player_rotation = 80.1
		on_right_wall = true
		jump_timer.start()
		#print("Can walk on wall (right)!")
		
	if is_on_floor():
		on_left_wall = false
		on_right_wall = false
		#print("Can NOT walk on wall!")
		player_rotation = 0
	
	#if not is_on_floor():
		#if velocity.x < 0 and player_rotation < 0 and not ray_cast_down.is_colliding():
			#print("bad left!")
		#if velocity.x > 0 and player_rotation > 0  and not ray_cast_down.is_colliding():
			#print("bad right!")
	#
	# flip sprite
	if direction > 0:
		direction_facing = 1
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		direction_facing = -1
		animated_sprite_2d.flip_h = true
	
	if player_rotation != 0:
		rotation = player_rotation
	else:
		rotation = 0
	
	# play animation
	if move_limit > 0.5:
		if direction == 0 or not is_on_floor():
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	
	if direction:
		velocity.x = direction * SPEED * move_limit
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) * move_limit
		
	if ((on_left_wall and direction == -1 and ray_cast_down_right.is_colliding()) 
	or (on_right_wall and direction == 1 and ray_cast_down_left.is_colliding())):
		velocity.y = WALL_RUN_SPEED 

	move_and_slide()
	



func _on_timer_timeout() -> void:
	move_limit = 0.6
	timer.stop()


func _on_timer_2_timeout() -> void:
	move_limit = 0.8
	timer_2.stop()


func _on_timer_3_timeout() -> void:
	move_limit = 1.0
	timer_3.stop()


func _on_jump_timer_timeout() -> void:
	#print("jump timer off")
	if (on_left_wall and ray_cast_left.is_colliding() or 
		on_right_wall and ray_cast_right.is_colliding()):
		velocity.y = 10
	rotation = 0
	on_left_wall = false
	on_right_wall = false
	jump_timer.stop()
	
func shoot(direction):
	var furball = FURBALL.instantiate()
	cur_furballs -= 1
	furball_label.text = ":"+str(cur_furballs) 
	add_collision_exception_with(furball)
	furball.position = Vector2(position.x, position.y - 10)
	furball.direction = direction
	get_tree().root.add_child(furball)
	

func _on_lick_timer_timeout() -> void:
	is_licking = false
	cur_furballs += 1
	furball_label.text = ":"+str(cur_furballs) 
	lick_timer.stop()
