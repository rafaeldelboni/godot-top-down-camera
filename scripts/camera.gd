extends Node3D

@export var target : Node3D
@export var offset : Vector3 = Vector3(0, 0, 3)
@export var smooth_speed : float = 5.0

@onready var background_camera = $base/background_viewport_container/background_viewport/background_camera
@onready var foreground_camera = $base/foreground_viewport_container/foreground_viewport/foreground_camera

# Called when the node enters the scene tree for the first time.
func _ready():
	background_camera.global_transform = global_transform
	foreground_camera.global_transform = global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	background_camera.global_transform = global_transform
	foreground_camera.global_transform = global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(target != null):
		var target_position = lerp(self.position, target.position + offset, smooth_speed * delta)
		self.position.x = target_position.x
		self.position.z = target_position.z
