extends Node
	
@onready var GameCam = $"GameCam"

func _ready() -> void:
	SignalBus.register_main.emit(self)
	ControllerManager.connect_controllers(2)
	ControllerManager.set_character(0, $"2DCharacters/3dDebug")
	#ControllerManager.set_character(1, $"2DCharacters/3dDebug2")
	#ControllerManager.set_character(1, $Kirby)
	ControllerManager.set_character(1, $"2DCharacters/Kirby")
	#$GameCam.add_target($"2DCharacters/Kirby")
	#$GameCam.add_target($"2DCharacters/Kirby2")
	#$GameCam.add_target($"2DCharacters/Mythra")
	#$GameCam.add_target($"2DCharacters/3dDebug")
	#$GameCam.add_target($"2DCharacters/3dDebug2")
