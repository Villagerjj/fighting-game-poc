extends State
class_name PlayerCrouch

var move_speed : float

var jump_height : float
var jump_time_to_peak : float
var jump_time_to_descent : float

var jump_velocity : float
var jump_gravity : float
var fall_gravity : float
var down_gravity : float


func enter():
	
	#if Input.is_action_pressed("left_"+str(controller_id)) or Input.is_action_pressed("right_"+str(controller_id)):
		#Transition.emit(self, "PlayerMove")
		#return
	
	
	move_speed = Character.move_speed
	
	jump_height = Character.jump_height
	jump_time_to_peak = Character.jump_time_to_peak
	jump_time_to_descent = Character.jump_time_to_descent
	
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
	down_gravity = fall_gravity * 2
	
	
	
	if Input.is_action_just_released("down_"+str(controller_id)):
		if Character.is_on_floor():
			if Character.velocity.x != 0:
				Transition.emit(self, "PlayerMove")
				return
			else:
				Transition.emit(self, "PlayerIdle")
				return
		else:
			Transition.emit(self, "PlayerAir")
			return
	else:
		Character.crouch_anim()

func physics_update(delta):
	
	Character.velocity.y += get_gravity() * delta
	#Character.velocity.x = get_horizontal_velocity() * move_speed
	
	
	
	

	var direction = Input.get_axis("left_"+str(controller_id), "right_"+str(controller_id))
	if direction:
		if Character.is_on_floor():
			Character.velocity.x = move_toward(Character.velocity.x, 0, move_speed/50)
		else:
			Character.velocity.x = direction * move_speed
		
	else:
		Character.velocity.x = move_toward(Character.velocity.x, 0, move_speed)


	Character.move_and_slide()
	
	if Input.is_action_just_released("down_"+str(controller_id)):
		if Character.is_on_floor():
			if is_zero_approx(Character.velocity.x):
				Transition.emit(self, "PlayerIdle")
				return
			else:
				Transition.emit(self, "PlayerMove")
				return
		else:
			Transition.emit(self, "PlayerFall")
			return
	else:
		Character.crouch_anim()
	
	#print(Character.velocity.y)

	
	
func get_horizontal_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left_"+str(controller_id)):
		horizontal -= 1.0
	if Input.is_action_pressed("right_"+str(controller_id)):
		horizontal += 1.0
	
	return horizontal

func get_gravity() -> float:
	return jump_gravity if Character.velocity.y < 0.0 else fall_gravity

	

func exit():
	pass
