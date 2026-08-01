extends CharacterBody2D

@export var move_speed : float = 300.0
@export var air_jumps_total : int = 1
@export_enum("2D", "3D", "DYNAMIC") var CHAR_MODE: int
@export var jump_height : float = 100
@export var jump_time_to_peak : float = 0.2
@export var jump_time_to_descent : float = 0.25


@onready var AnimatedSprite : AnimatedSprite2D = $AnimatedSprite2D


@export var target_height_meters : float = 1.0

const PIXELS_PER_METER = Global.PIXELS_PER_METER

func _ready() -> void:
	scale_to_target_height()

func scale_to_target_height() -> void:
	if not AnimatedSprite or not AnimatedSprite.sprite_frames:
		push_error("AnimatedSprite2D or its frames are missing.")
		return

	var current_animation := AnimatedSprite.animation
	if current_animation == "":
		current_animation = AnimatedSprite.sprite_frames.get_animation_names()[0]
		AnimatedSprite.play(current_animation)

	var frame_texture := AnimatedSprite.sprite_frames.get_frame_texture(current_animation, 0)
	if frame_texture == null:
		push_error("Could not retrieve the first frame texture.")
		return

	var actual_frame_height_px = frame_texture.get_height()
	var target_height_pixels = target_height_meters * PIXELS_PER_METER

	if actual_frame_height_px == 0:
		push_error("Frame height is 0, cannot scale.")
		return

	var scale_factor = target_height_pixels / actual_frame_height_px
	self.scale = Vector2(scale_factor, scale_factor)


func attack_anim(AttackFinished : Callable):
	print("Entered the local attack area")
	 
	# Ensure the signal is not connected multiple times
	if !AnimatedSprite.animation_finished.is_connected(AttackFinished):
		AnimatedSprite.animation_finished.connect(AttackFinished)
		if !AnimatedSprite.animation_finished.is_connected(AttackFinished):
			print("FAILED TO CONNECT")
		else:
			print("Successfully connected the animation_finished signal!")
		
	# Play the "attack" animation
	AnimatedSprite.play("attack")
	
	# Confirm the animation is playing correctly
	print("Current animation: " + str(AnimatedSprite.animation))
	
	

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

func crouch_anim():
	AnimatedSprite.play("crouch")

func fall_anim():
	AnimatedSprite.play("fall")

func air_jump_anim():
	AnimatedSprite.play("air_jump")

func jump_anim():
	AnimatedSprite.play("jump")

func move_anim():
	AnimatedSprite.play("move_right")

func idle_anim():
	AnimatedSprite.play("idle")

func stop_anim():
	AnimatedSprite.stop()

func _physics_process(_delta: float) -> void:
	if velocity.x >= 1:
		AnimatedSprite.flip_h = false
	elif velocity.x <= -1:
		AnimatedSprite.flip_h = true


func _on_animated_sprite_2d_animation_finished() -> void:
	print("Signal Emitted!")
	if AnimatedSprite.animation == "attack":
		print("Finished the local attack")
		# Disconnect the signal to avoid multiple connections
		for dict in AnimatedSprite.animation_finished.get_connections():
			AnimatedSprite.animation_finished.disconnect(dict.callable)
