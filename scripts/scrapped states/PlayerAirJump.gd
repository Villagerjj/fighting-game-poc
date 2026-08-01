extends State
class_name PlayerAirJump


var air_jumps_total : int
var air_jumps_current : int
var move_speed : float

var jump_height : float
var jump_time_to_peak : float
var jump_time_to_descent : float

var jump_velocity : float
var jump_gravity : float
var fall_gravity : float

func enter():
	
	
	move_speed = Character.move_speed
	jump_height = Character.jump_height
	jump_time_to_peak = Character.jump_time_to_peak
	jump_time_to_descent = Character.jump_time_to_descent
	
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
	
	air_jumps_current -= 1
	Character.velocity.y = jump_velocity

func physics_update(delta):
	
	
	Character.velocity.y += get_gravity() * delta
	Character.velocity.x = get_horizontal_velocity() * move_speed
	
	if Input.is_action_just_pressed("jump_"+str(controller_id)):
		

	var direction = Input.get_axis("left_"+str(controller_id), "right_"+str(controller_id))
	if direction:
		Character.velocity.x = direction * move_speed
	else:
		Character.velocity.x = move_toward(Character.velocity.x, 0, move_speed)


	Character.move_and_slide()
	
	#print(Character.velocity.y)
	
	if Character.velocity.y > 1.5:
		Transition.emit(self, "PlayerAir")
	
	if Character.is_on_floor():
		#print("ur on da floor")
		Transition.emit(self, "PlayerIdle")

func get_horizontal_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left_"+str(controller_id)):
		horizontal -= 1.0
	if Input.is_action_pressed("right_"+str(controller_id)):
		horizontal += 1.0
	
	return horizontal

func get_gravity() -> float:
	return jump_gravity if Character.velocity.y < 0.0 else fall_gravity
