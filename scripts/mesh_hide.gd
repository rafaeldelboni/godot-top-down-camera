extends MeshInstance3D

@export var smooth_fade : float = 5.0
@export var min_fade : float = 1.0
@export var max_fade : float = 15.0
@export var min_distance_to_fade : float = 2

@onready var player : Node3D = get_tree().get_nodes_in_group("players")[0]  
@onready var material : Material

func set_fade(delta:float) -> void:
	material.distance_fade_max_distance = lerp(material.distance_fade_max_distance, max_fade, smooth_fade * delta)

func set_appear(delta:float) -> void:
	material.distance_fade_max_distance = lerp(material.distance_fade_max_distance, min_fade, smooth_fade * delta)

func _ready() -> void:
	self.set_surface_override_material(0, self.get_surface_override_material(0).duplicate())
	material = self.get_surface_override_material(0)
	material.set_distance_fade(1)
	material.distance_fade_min_distance = min_fade
	material.distance_fade_max_distance = max_fade
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.z > position.z:
		set_appear(delta)
	elif position.z - player.position.z > min_distance_to_fade:
		set_appear(delta)
	else:
		set_fade(delta)
