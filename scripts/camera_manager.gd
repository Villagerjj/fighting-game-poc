extends Node

var MainCam_2D : PhantomCamera2D 
var MainCam_3D : PhantomCamera3D
@onready var PhantomHosts : Array[PhantomCameraHost] = PhantomCameraManager.get_phantom_camera_hosts()

@onready var Cam2D : Camera2D = PhantomHosts.front().camera_2d
@onready var Cam3D : Camera3D = PhantomHosts.front().camera_3d

var Cam3D_Center_Packed : PackedScene = preload("res://assets/modules/3D_characters_center/3d_characters_center.tscn")
var Cam3D_Center : Marker3D

func _ready() -> void:
	var temp_2D_array := PhantomCameraManager.get_phantom_camera_2ds()
	if !temp_2D_array.is_empty():
		MainCam_2D = temp_2D_array.front()
		
	var temp_3D_array = PhantomCameraManager.get_phantom_camera_3ds()
	if !temp_3D_array.is_empty():
		MainCam_3D = temp_3D_array.front()

func update_main_2d_cam(cam : PhantomCamera2D):
	MainCam_2D = cam

func update_main_3d_cam(cam : PhantomCamera3D):
	MainCam_3D = cam

func add_follow_2D(character : CharacterBody2D):
	if MainCam_2D:
		MainCam_2D.append_follow_targets(character)

## this adds either a marker3D node, or other form of 3D node to the currently active 3D camera
func add_follow_3D(target : Node3D):
	if MainCam_3D and MainCam_3D.look_at_mode == MainCam_3D.LookAtMode.GROUP:
		MainCam_3D.append_look_at_target(target)
		
		if !Cam3D_Center:
			Cam3D_Center = Cam3D_Center_Packed.instantiate()
			StageManager.current_stage.stage_3D.add_child(Cam3D_Center)
		
		MainCam_3D.set_follow_target(CameraManager.Cam3D_Center) 
		Cam3D_Center.targets.append(target)
		
	else:
		printerr("NO CAMERA")
