extends State
class_name PlayerIdle

var move_speed : float

func enter():
	move_speed = Character.move_speed
	#if Input.is_action_pressed("left_"+str(controller_id)) or Input.is_action_pressed("right_"+str(controller_id)):
		#Transition.emit(self, "PlayerMove")
		#return
	Character.idle_anim()

func physics_update(_delta):
	Character.velocity.x = move_toward(Character.velocity.x, 0, move_speed)
	
	if Input.is_action_just_pressed("attack_"+str(controller_id)):
		Transition.emit(self, "PlayerAttack")
		return
	

	if Input.is_action_just_pressed("jump_"+str(controller_id)):
		Transition.emit(self, "PlayerJump")
		return
	if Input.is_action_pressed("left_"+str(controller_id)) or Input.is_action_pressed("right_"+str(controller_id)):
		Transition.emit(self, "PlayerMove")
		return
	
	
	Character.move_and_slide()
	
	if Input.is_action_pressed("down_"+str(controller_id)):
		Transition.emit(self, "PlayerCrouch")

func exit():
	#print("exiting")
	#Character.stop_anim()
	pass
