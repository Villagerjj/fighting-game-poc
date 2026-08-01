extends Node3D
# On the 3D model node or controlling script


var character_2d : CharacterBody2D
var pixel_scale : float = 0.01
@export var offset : Vector2 = Vector2(-12.8, 9.6) #Vector2(-12.8 * 2, 9.6 * 2) #  # You can use this if needed

func _ready() -> void:
	while character_2d == null:
		await SignalBus.model_data_assigned
	position.z = StageManager.current_stage.subviewport_sprite.position.z

func _process(_delta):
	var scale_factor = Global.PIXELS_PER_METER# * pixel_scale

	position.x = (character_2d.position.x / scale_factor) + offset.x
	position.y = -(character_2d.position.y / scale_factor) + offset.y
