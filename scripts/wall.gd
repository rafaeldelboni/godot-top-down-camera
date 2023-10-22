extends CSGBox3D

@onready var player : Node3D = get_tree().get_nodes_in_group("players")[0]  

func set_to_foreground() -> void:
	if not get_layer_mask_value(2):
		set_layer_mask_value(1, false)
		set_layer_mask_value(2, true)

func set_to_background() -> void:
	if not get_layer_mask_value(1):
		set_layer_mask_value(1, true)
		set_layer_mask_value(2, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.z > position.z:
		set_to_background()
	else:
		set_to_foreground()
