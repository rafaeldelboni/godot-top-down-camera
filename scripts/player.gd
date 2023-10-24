extends CharacterBody3D

## Character maximum speed on the ground.
@export var walk_speed : float = 3.0
@export var run_speed : float = 5.0
## Movement acceleration (how fast character achieve maximum speed)
@export var acceleration := 5.0
## Player model rotaion speed
@export var rotation_speed : float = 12.0
## Stopping speed between the idle and running states.
@export var stopping_speed := 1.0

@onready var speed : float = walk_speed
@onready var visuals : Node3D = $visuals
@onready var last_strong_direction : Vector3 = Vector3.FORWARD
@onready var animation_tree = $AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_input() -> Vector3:
	var raw_input := Input.get_vector("left", "right", "forward", "backward")
	var input = (transform.basis * Vector3(raw_input.x, 0, raw_input.y)).normalized()
	return input

func orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var left_axis := Vector3.UP.cross(direction)
	var rotation_basis := Basis(left_axis, Vector3.UP, direction).get_rotation_quaternion()
	var model_scale := visuals.transform.basis.get_scale()
	visuals.transform.basis = Basis(visuals.transform.basis.get_rotation_quaternion().slerp(rotation_basis, delta * rotation_speed)).scaled(
		model_scale
	)

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var direction = get_input()
	
	# To not orient quickly to the last input, we save a last strong direction,
	# this also ensures a good normalized value for the rotation basis.
	if direction.length() > 0.2:
		last_strong_direction = direction.normalized()

	orient_character_to_direction(last_strong_direction, delta)
	
	# Check inputs to set Run
	if Input.is_action_just_pressed("run"):
		speed = run_speed
	if Input.is_action_just_released("run"):
		speed = walk_speed
	
	# Check velocity to set walking state
	if direction.length() == 0 and velocity.length() < stopping_speed:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		animation_tree.set_moving(false)
	else:
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		animation_tree.set_moving(true)
		animation_tree.set_moving_speed(inverse_lerp(walk_speed, run_speed, velocity.length()))

	move_and_slide()
