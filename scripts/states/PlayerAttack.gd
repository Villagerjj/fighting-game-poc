extends State
class_name PlayerAttack


#func enter():
	#print("Attack state entered")
	#Character.attack_anim()
	#await Character.AttackFinished
	#print("Attack finished!")
	#Transition.emit(self, "PlayerIdle")
	#
#func update(_delta):
	## attackfin()
	#pass
#
#func attackfin():
	#
	#pass
	#
#func exit():
	#pass




func enter():
	#print("Attack state entered")
	
	Character.attack_anim(Callable(self, "attackfin"))
	
	
	#print("Sent the callable!")
	
func attackfin(_discard = null):
	#print("Attack finished!")

	var direction = Input.get_axis("left_"+str(controller_id), "right_"+str(controller_id))
	if !direction:
		Transition.emit(self, "PlayerIdle")
		return
	else:
		Transition.emit(self, "PlayerMove")
		return
	
	#Character.AttackFinished.disconnect(attackfin)
	
func physics_update(_delta):
	#await attackfin()
	pass


	
func exit():
	pass
