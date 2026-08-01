extends State
class_name PlayerAir

var air_jumps_total : int
var air_jumps_current : int

var move_speed : float

var jump_height : float
var jump_time_to_peak : float
var jump_time_to_descent : float

var jump_velocity : float
var jump_gravity : float
var fall_gravity : float
var down_gravity : float

func enter():
	#Character.jump_anim()
	
	move_speed = Character.move_speed
	air_jumps_total = Character.air_jumps_total
	air_jumps_current = air_jumps_total
	
	jump_height = Character.jump_height
	jump_time_to_peak = Character.jump_time_to_peak
	jump_time_to_descent = Character.jump_time_to_descent
	
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func physics_update(delta):
	
	
	Character.velocity.y += get_gravity() * delta
	Character.velocity.x = get_horizontal_velocity() * move_speed
	
	if Input.is_action_just_pressed("jump_"+str(controller_id)):
		if air_jumps_current > 0:
			air_jumps_current -= 1
			Character.velocity.y = jump_velocity

	var direction = Input.get_axis("left_"+str(controller_id), "right_"+str(controller_id))
	if !direction:
		Character.velocity.x = move_toward(Character.velocity.x, 0, move_speed)


	Character.move_and_slide()
	
	
	#print(Character.velocity.y)
	if Input.is_action_pressed("down_"+str(controller_id)):
		Transition.emit(self, "PlayerCrouch")
		return
	else:
		if Character.velocity.y < 1.5:
			if air_jumps_current < air_jumps_total:
				Character.air_jump_anim()
			else:
				Character.jump_anim()

	
	if Character.is_on_floor():
		if is_zero_approx(Character.velocity.x):
			Transition.emit(self, "PlayerIdle")
			return
		else:
			Transition.emit(self, "PlayerMove")
			return
	elif air_jumps_current <= 0:
		Transition.emit(self, "PlayerFall")
		return
			

func get_horizontal_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left_"+str(controller_id)):
		horizontal -= 1.0
	if Input.is_action_pressed("right_"+str(controller_id)):
		horizontal += 1.0
	
	return horizontal

func get_gravity() -> float:
	return jump_gravity if Character.velocity.y < 0.0 else fall_gravity
