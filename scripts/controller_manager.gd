extends Node

var controllers : Array
var control_script = preload("res://scripts/player_controller.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

## connects the specified amount of controllers
func connect_controllers(amount : int = 1):
	for i in amount:
		var controller = control_script.instantiate()
		self.add_child(controller)
		controllers.append(controller) 
		var temp = controllers.find(controller, 0)
		controllers[temp].controller_id = temp
		
func set_character(controller_id : int, character : CharacterBody2D):
	if !character:
		print("ERROR: Character '" + str(character) + "' does NOT EXIST!!!")
		return
	controllers[controller_id].Character = character
	SignalBus.character_assigned.emit(0)
	print("set controller " + str(controllers[controller_id].controller_id) + " to " + str(controllers[controller_id].Character))
	
	StageManager.setup_character(character)
	
	
