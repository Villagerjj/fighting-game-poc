extends Node

var MAIN : Node


const PIXELS_PER_METER = 100.0 #how many pixels is equal to 1 meter (100px = 1m)
const SCREEN_SIZE = Vector2(1280, 960)  # subviewport resolution



func _ready() -> void:
	SignalBus.register_main.connect(_register_main)

func _register_main(node : Node):
	MAIN = node
