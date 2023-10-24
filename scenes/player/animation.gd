extends AnimationTree
@onready var animation_player = $"../AnimationPlayer"
var moving_blend_path := "parameters/Move/blend_position"

# False : set animation to "idle"
# True : set animation to "move"
@onready var moving : bool = false : set = set_moving

# Blend value between the walk and run cycle
# 0.0 walk - 1.0 run
@onready var move_speed : float = 0.0 : set = set_moving_speed
@onready var state_machine : AnimationNodeStateMachinePlayback = self.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.active = true
	animation_player["playback_default_blend_time"] = 0.2

func set_moving(value : bool):
	moving = value
	if moving:
		state_machine.travel("Move")
	else:
		state_machine.travel("Idle")

func set_moving_speed(value : float):
	move_speed = clamp(value, 0.0, 1.0)
	self.set(moving_blend_path, move_speed)
