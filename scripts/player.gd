extends CharacterBody3D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var visuals : Node3D = $visuals
@onready var last_strong_direction : Vector3 = Vector3.FORWARD
var walking : bool = false
var running : bool = false

## Character maximum speed on the ground.
@export var walk_speed : float = 3.0
@export var run_speed : float = 6.0
## Movement acceleration (how fast character achieve maximum speed)
@export var acceleration := 5.0
## Player model rotaion speed
@export var rotation_speed : float = 12.0
## Stopping speed between the idle and running states.
@export var stopping_speed := 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

func start_walking() -> void :
	walking = true
	if not running:
		print("walk1")
		animation_player.play("Walking")
	else:
		print("run1")
		animation_player.play("Running")

func stop_walking() -> void :
	walking = false
	print("idle1")
	animation_player.play("Idle")
	
func start_running() -> void :
	running = true
	if walking:
		print("run2")
		animation_player.play("Running")
	
func stop_running() -> void :
	running = false
	if walking:
		print("walk2")
		animation_player.play("Walking")
		
func orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction).get_rotation_quaternion()
	var model_scale := visuals.transform.basis.get_scale()
	visuals.transform.basis = Basis(visuals.transform.basis.get_rotation_quaternion().slerp(rotation_basis, delta * rotation_speed)).scaled(
		model_scale
	)
	
func _ready() -> void:
	animation_player.set_blend_time("Idle", "Walking", 0.2)
	animation_player.set_blend_time("Walking", "Idle", 0.2)
	animation_player.set_blend_time("Walking", "Running", 0.25)
	animation_player.set_blend_time("Running", "Walking", 0.25 )
	animation_player.set_blend_time("Running", "Idle", 0.2)
	animation_player.set_blend_time("Idle", "Running", 0.2)

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# To not orient quickly to the last input, we save a last strong direction,
	# this also ensures a good normalized value for the rotation basis.
	if direction.length() > 0.2:
		last_strong_direction = direction.normalized()

	orient_character_to_direction(last_strong_direction, delta)
	
	# Check inputs to set Run
	if Input.is_action_just_pressed("run"):
		start_running()
	if Input.is_action_just_released("run"):
		stop_running()
	
	# Calculate speed based if player is running or walking
	var speed : float = walk_speed if not running else run_speed

	# Check velocity to set walking state
	if direction.length() == 0 and velocity.length() < stopping_speed:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		if walking:
			stop_walking()
	else:
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		if not walking:
			start_walking()

	move_and_slide()
