extends Node2D

@export var MODE : StageManager.StageMode
#@onready var stage_2D : SubViewport = $"2D Elements" ##this is the subviewport

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	SignalBus.init_stage.emit(self, MODE)
