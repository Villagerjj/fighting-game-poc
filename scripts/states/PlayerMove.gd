extends State
class_name PlayerMoving

var move_speed : float
var air_jumps_total : int
var air_jumps_current : int

var jump_height : float
var jump_time_to_peak : float
var jump_time_to_descent : float

var jump_velocity : float
var jump_gravity : float
var fall_gravity : float



func enter():
	move_speed = Character.move_speed


func physics_update(_delta):
	if !Character.is_on_floor():
		Transition.emit(self, "PlayerAir")
		return
	
	Character.velocity.x = get_horizontal_velocity() * move_speed
	
	if Input.is_action_just_pressed("jump_"+str(controller_id)):
		Transition.emit(self, "PlayerJump")
		return
	
	#var direction = Input.get_axis("left_"+str(controller_id), "right_"+str(controller_id))
	#if direction:
		#Character.velocity.x = direction * move_speed
		#
	#else:
		#Transition.emit(self, "PlayerIdle")
		##Character.velocity.x = move_toward(Character.velocity.x, 0, move_speed)
		##Character.idle_anim()
	Character.move_and_slide()
	
	if Input.is_action_pressed("down_"+str(controller_id)):
			Transition.emit(self, "PlayerCrouch")
			return
	
const idle_frame_max : int = 10 #the number of frames before switching to the idle state
var current_idle_frame : int = idle_frame_max

func get_horizontal_velocity() -> float:
	var horizontal := 0.0
	
	# Check if left or right is pressed
	if Input.is_action_pressed("left_"+str(controller_id)) and !Input.is_action_pressed("right_"+str(controller_id)):
		horizontal = -1.0  # Move left only if not pressing right
		current_idle_frame = idle_frame_max
		Character.move_anim()
	elif Input.is_action_pressed("right_"+str(controller_id)) and !Input.is_action_pressed("left_"+str(controller_id)):
		horizontal = 1.0  # Move right only if not pressing left
		current_idle_frame = idle_frame_max
		Character.move_anim()
	else:
		if current_idle_frame <= 0:
			Transition.emit(self, "PlayerIdle")
		else:
			current_idle_frame -= 1
	
	# If both are pressed, maintain last valid direction or stop (optional behavior)
	return horizontal

#var last_direction = 0.0  # This stores the last input direction
#
#func get_horizontal_velocity() -> float:
	#var horizontal := 0.0
#
	## If both are pressed, use the last direction pressed
	#if Input.is_action_just_pressed("left_"+str(controller_id)):
		#last_direction = -1.0
	#elif Input.is_action_just_pressed("right_"+str(controller_id)):
		#last_direction = 1.0
	#
	## Update horizontal velocity based on last valid input
	#if Input.is_action_pressed("left_"+str(controller_id)):
		#horizontal = -1.0
	#elif Input.is_action_pressed("right_"+str(controller_id)):
		#horizontal = 1.0
	#
	## If both directions are pressed, rely on the last direction
	#if Input.is_action_pressed("left_"+str(controller_id)) and Input.is_action_pressed("right_"+str(controller_id)):
		#horizontal = last_direction
	#
	#return horizontal

#func get_horizontal_velocity() -> float:
	#var horizontal := 0.0
	#
	#if Input.is_action_pressed("left_"+str(controller_id)):
		#horizontal -= 1.0
	#if Input.is_action_pressed("right_"+str(controller_id)):
		#horizontal += 1.0
	#
	#return horizontal
