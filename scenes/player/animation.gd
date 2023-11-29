class_name PlayerAnimation extends AnimationTree
@onready var animation_player = $"../AnimationPlayer"
var moving_blend_path := "parameters/Move/blend_position"

# Blend value between the idle, walk and run cycles
# 0.0 idle - 0.5 walk - 1.0 run
@onready var move_speed : float = 0.0 : set = set_moving_speed
@onready var state_machine : AnimationNodeStateMachinePlayback = self.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.active = true
	animation_player["playback_default_blend_time"] = 0.2

func set_moving_speed(value : float) -> void:
	print(value)
	move_speed = clamp(value, 0.0, 1.0)
	self.set(moving_blend_path, move_speed)
