extends Node

@export var initial_state : State

# this is a base/template for all player controllers
var states : Dictionary = {}
var current_state : State

var Character : CharacterBody2D
var controller_id := 0

var move_speed : float
var air_jumps_total : int 
var air_jumps_current : int 

var jump_height : float 
var jump_time_to_peak : float 
var jump_time_to_descent : float 

var jump_velocity : float 
var jump_gravity : float 
var fall_gravity : float

func _ready() -> void:
	while Character == null:
		await SignalBus.character_assigned
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transition.connect(on_child_transition)
	
	print(states)
	
	if initial_state:
		initial_state.Character = Character
		initial_state.controller_id = controller_id
		initial_state.enter()
		current_state = initial_state
	
	

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
			

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
		


func on_child_transition(state, new_state_name):
	#print("Swapping State to ", new_state_name)
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("Error: " + str(new_state_name) + " Does not exist!")
		return
	
	if current_state:
		current_state.exit()
		
	new_state.Character = Character
	new_state.controller_id = controller_id
	new_state.enter()
	
	current_state = new_state
	
