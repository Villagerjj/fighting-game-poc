extends Node

@export var MODE : StageManager.StageMode
@export var FOV : float = 20
@onready var stage_3D := $"3D Elements"
@onready var stage_2D : SubViewport = $"2D Elements" ##this is the subviewport
@onready var subviewport_sprite := $"3D Elements/Sprite3D"
@onready var follow_path : Path3D = $"3D Elements/Path3D"


func _ready() -> void:
	SignalBus.init_stage.emit(self, MODE)
	#Global._2d_to_3d_scale = 100
	
