extends CharacterBody2D

@export var move_speed : float = 200.0
@export var air_jumps_total : int = 1

@export var jump_height : float = 100
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.5

#@onready var AnimTree : AnimationTree = $SubViewportContainer/SubViewport/HalfTShirtGirlAnimations/AnimationTree
#@onready var AnimPlayer : AnimationPlayer = $SubViewportContainer/SubViewport/HalfTShirtGirlAnimations/AnimationPlayer

#@onready var model = $SubViewportContainer/SubViewport/HalfTShirtGirlAnimations

#@onready var ViewScale = model.scale.z

@export_enum("2D", "3D", "DYNAMIC") var CHAR_MODE: int

@export var target_height_meters : float = 1.75  # Default character height
var original_model_height : float
var target_model_scale : float = 1.0


@onready var Model = $HalfTShirtGirlAnimations
var AnimPlayer : AnimationPlayer
var ViewScale

func _ready() -> void:
	SignalBus.model_data_assigned.connect(_init_3D_stuff)
	while Model == null:
		await SignalBus.model_data_assigned
	scale_3d_model_to_height()
	
	

func _init_3D_stuff(model_parent):
	if model_parent != self:
		await SignalBus.model_data_assigned
	AnimPlayer = Model.get_node('AnimationPlayer')
	ViewScale = Model.scale.z
	
	#$SubViewportContainer.pivot_offset = $SubViewportContainer.size / 2

func attack_anim(AttackFinished : Callable):
	print("Entered the local attack area")
	 
	if !AnimPlayer.animation_finished.is_connected(_on_animated_sprite_2d_animation_finished):
		AnimPlayer.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	# Ensure the signal is not connected multiple times
	if !AnimPlayer.animation_finished.is_connected(AttackFinished):
		AnimPlayer.animation_finished.connect(AttackFinished)
		if !AnimPlayer.animation_finished.is_connected(AttackFinished):
			print("FAILED TO CONNECT")
		else:
			print("Successfully connected the animation_finished signal!")
		
	# Play the "attack" animation
	AnimPlayer.play("Attack")
	
	# Confirm the animation is playing correctly
	#print("Current animation: " + str(AnimPlayer.current_animation))
	
	

#func attack_anim():
	#print("entered the local attack area")
	#if !$AnimatedSprite2D.animation_finished.is_connected(_on_attack_anim_finished):
		#$AnimatedSprite2D.animation_finished.connect(_on_attack_anim_finished)
		#print("connected signal, gonna try an play the animation")
	#if $AnimatedSprite2D.animation_finished.is_connected(_on_attack_anim_finished):
		#print("Signal is Connected!")
	#$AnimatedSprite2D.play("attack")
	#print($AnimatedSprite2D.animation)
#
#func _on_attack_anim_finished(anim_name):
	#print("finished the local attack")
	#print(anim_name)
	#AttackFinished.emit()
	##$AnimatedSprite2D.animation_finished.disconnect(_on_attack_anim_finished)


#var crouch_val := 0.0
func scale_3d_model_to_height():
	if not Model:
		push_error("Model not assigned!")
		return

	# Try to find a MeshInstance3D in the model hierarchy
	var mesh_node = Model.get_node_or_null("MeshInstance3D")
	if mesh_node == null:
		mesh_node = Model.get_child(0)
		mesh_node = mesh_node.get_node_or_null("Armature/MeshInstance3D")  # if nested
	if mesh_node == null:
		mesh_node = Model.get_child(0).get_node_or_null("Armature/Skeleton3D/MeshInstance3D")  # if nested

	if mesh_node == null or not mesh_node is MeshInstance3D:
		push_error("No MeshInstance3D found in Model")
		return

	var mesh = mesh_node.mesh
	if mesh == null:
		push_error("MeshInstance3D has no mesh")
		return

	var unscaled_height = mesh.get_aabb().size.y
	if unscaled_height <= 0.01:
		push_error("Mesh has zero height")
		return

	# Scale factor = desired height in meters / unscaled height in meters
	target_model_scale = target_height_meters / unscaled_height
	Model.scale = Vector3.ONE * target_model_scale
	ViewScale = target_model_scale  # used later for horizontal flipping


func crouch_anim():
	#AnimTree[parameters/Crouch/blend_amount] = crouch_val
	AnimPlayer.play("Crouching")

func fall_anim():
	AnimPlayer.play("Falling")

func air_jump_anim():
	AnimPlayer.play("Jump")

func jump_anim():
	AnimPlayer.play("Jump")

func move_anim():
	AnimPlayer.play("Move_Right")

func idle_anim():
	AnimPlayer.play("Idle")

func stop_anim():
	AnimPlayer.stop()

func _physics_process(_delta: float) -> void:
	if velocity.x >= 1:
		Model.scale.z = ViewScale
	elif velocity.x <= -1:
		Model.scale.z = -ViewScale

	#update_3d_from_2d()
	
	#$SubViewportContainer/SubViewport/Camera3D.position.z = get_parent().get_node('GameCam').position.x
	#$SubViewportContainer/SubViewport/Camera3D.position.y = get_parent().get_node('GameCam').position.y

#func update_3d_from_2d():
	#var game_cam = get_parent().get_node('GameCam')
	##var camera_3d = $SubViewportContainer/SubViewport/Camera3D
	#
	## Get the difference between the 2D character's position and the 2D camera
	#var character_position_2d = self.global_position
	##var camera_position_2d = game_cam.global_position  # Assuming this is your 2D camera's position
#
#
	##
	#
	#model.position.z = character_position_2d.x
	#model.position.y = character_position_2d.y - 1.35  #this 1.35 is just to keep the character in view
	#
	##camera_3d.position.z = camera_position_2d.x
	##camera_3d.position.y = camera_position_2d.y
	#



func _on_animated_sprite_2d_animation_finished(animation) -> void:
	#print("Signal Emitted!")
	if animation == "Attack":
		SignalBus.add_trauma.emit()
		# Disconnect the signal to avoid multiple connections
		for dict in AnimPlayer.animation_finished.get_connections():
			AnimPlayer.animation_finished.disconnect(dict.callable)
