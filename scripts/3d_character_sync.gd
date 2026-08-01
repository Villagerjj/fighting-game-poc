extends Node3D
# On the 3D model node or controlling script


# Reference to the CharacterBody2D
var character_2d : CharacterBody2D

func _ready() -> void:
	while character_2d == null:
		await SignalBus.model_data_assigned

func _process(_delta):
	position.x = character_2d.position.x / Global.PIXELS_PER_METER
	position.y = -(character_2d.position.y / Global.PIXELS_PER_METER)
	#print(position)
