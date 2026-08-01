extends Node

enum StageMode {S_2D, S_3D, DYNAMIC}
enum CharMode {C_2D, C_3D, DYNAMIC}
var current_stage : Node

var stage_2D_subviewport_packed := preload("res://assets/modules/2D_subviewport/2D_sub_viewport_container.tscn")
var stage_2D_subviewport : SubViewport



func _ready() -> void:
	SignalBus.init_stage.connect(_init_stage)

func setup_character(character : CharacterBody2D):
	
	## Setup the camera layers
	match character.CHAR_MODE:
		CharMode.C_2D:
			match current_stage.MODE:
				StageMode.S_2D:
					CameraManager.add_follow_2D(character)
				StageMode.S_3D:
					var char_cam_marker = Node3D.new()
					
					##sets up the 3D tracker for the 2D character.
					char_cam_marker.set_script(load("res://scripts/2d_character_sync.gd"))
					char_cam_marker.character_2d = character
					## adds the 3D Marker to the 3D Stage
					if !current_stage:
						await SignalBus.init_stage
					else:
						print(current_stage)
					
					while !char_cam_marker.get_parent():
						current_stage.stage_3D.add_child(char_cam_marker, false)
					
					char_cam_marker.set_process(true)
					
					#var CSG = CSGBox3D.new()
					#CSG.scale = Vector3(1000.0,1000.0,1000.0)
					#CSG.reparent(current_stage)
					#
					CameraManager.add_follow_3D(char_cam_marker)
					
					
					## moves the 2D character to the subviewport
					character.reparent(stage_2D_subviewport)
			
					##tells the 3D marker to start updating
					SignalBus.model_data_assigned.emit(character)
		
		CharMode.C_3D:
			var Char_children = character.get_children()
			for child in Char_children:
				if child is Node3D:
					character.remove_child(child)
					
					match current_stage.MODE:
						StageMode.S_2D:
							child.set_script(load("res://scripts/3d_character_sync.gd"))
							child.character_2d = character
							
							child.set_process(true)
							character.Model = child
							character.get_parent().get_parent().get_node('GameCam/SubViewportContainer/SubViewport/3DCharacters').add_child(child)
							CameraManager.add_follow_2D(character)
							SignalBus.model_data_assigned.emit(character)
						StageMode.S_3D:
							child.set_script(load("res://scripts/2d_character_sync.gd"))
							child.character_2d = character
							
							#ensure the 2D character is scaled properly
							#character.scale *= (Global.PIXELS_PER_METER * current_stage.subviewport_sprite.pixel_size) 
							
							child.set_process(true)
							character.Model = child
							## makes sure to move the 2D sprites to the new subviewport
							character.reparent(stage_2D_subviewport)
							
							## moves the 3D mesh for the 3D character to the same scope as the stage
							current_stage.stage_3D.add_child(child)
							#ensures the 3D mesh is the proper scale
							#child.scale *= (Global.PIXELS_PER_METER * current_stage.subviewport_sprite.pixel_size) 
							
							
							##self explanitory
							CameraManager.add_follow_3D(child)
							SignalBus.model_data_assigned.emit(character)
							pass
						_:
							printerr("bro, fix ur code :/")
					
					
					
					#child.queue_free()
					

func _init_stage(stage, mode : StageMode):
	if !stage:
		print("u need to send the root node of ur stage")
		return
	current_stage = stage
	
	match mode:
		StageMode.S_2D:
			pass
			
		StageMode.S_3D:
			#print("stage: ", stage)
			#print("stage_2D: ", stage.stage_2D)
			
			## adds a subviewport to the 3D sprite inside of the 3D stage if none is detected
			if !current_stage.stage_2D:
				print("stage 2d is not a SubViewport / does not exist")
				stage_2D_subviewport = stage_2D_subviewport_packed.instantiate()
				
				#adds the subviewport as a simbling to the stage data
				stage.stage_3D.add_sibling(stage_2D_subviewport)
				
				# sets up the viewport texture for the sprite 3D
				var view = ViewportTexture.new()
				view.viewport_path = stage_2D_subviewport.get_path()
				
				# sets the texture to the new subviewport
				stage.subviewport_sprite.texture = view 
				
				## grab the 2D stage data (collisions for example), and add to the subviewport
				if stage.stage_2D == Node:
					stage.stage_2D.reparent(stage_2D_subviewport)
			else:
				stage_2D_subviewport = stage.stage_2D
			
			
			#stage.subviewport_sprite.pixel_size = 1.0 / Global.PIXELS_PER_METER
			#add the subviewport to the scene tree since it does not exist, not really needed
			#if Global.MAIN:
				#Global.MAIN.add_child(stage_2D_subviewport)
			#else:
				#print("MAIN not initalized 1")
				#await SignalBus.register_main
				#if Global.MAIN:
					#Global.MAIN.add_child(stage_2D_subviewport)
				#else:
					#print("MAIN not initalized 2")
					#await SignalBus.register_main
					#Global.MAIN.add_child(stage_2D_subviewport)
			
			
			
			## since this is 3D, we need to remove the 2D phantom cam stuff
			CameraManager.MainCam_2D.queue_free()
			if Global.MAIN:
				if Global.MAIN.GameCam:
					Global.MAIN.GameCam.queue_free()
			else:
				await SignalBus.register_main
				if Global.MAIN.GameCam:
					Global.MAIN.GameCam.queue_free()
			
			
			## spawn in the 3D Cam data, and assign it to a track.
			
			# first, we need to make a cam 3D
			var Cam_3D = Camera3D.new()
			
			# add a phantom cam host as a child
			var PCamHost = PhantomCameraHost.new()
			Cam_3D.add_child(PCamHost)
			
			# add the cam3d to the scene
			stage.stage_3D.add_child(Cam_3D)
			
			# add a phantom cam 3D as a sibling
			var PCam3D = PhantomCamera3D.new()
			
			# set the follow mode to path
			PCam3D.follow_mode = PCam3D.FollowMode.PATH
			PCam3D.set_follow_path(stage.follow_path)
		
			#set cam attributes
			PCam3D.camera_3d_resource = Camera3DResource.new()
			PCam3D.camera_3d_resource.fov = current_stage.FOV
			# set the lookat mode to group
			PCam3D.look_at_mode = PCam3D.LookAtMode.GROUP
			PCam3D.append_look_at_target(stage)
			stage.stage_3D.add_child(PCam3D)
			## last minute tweaks
			PCam3D.follow_damping = true
			PCam3D.look_at_damping = true
			
			
			
			## make sure to set the 3D cam and maincam_3d in the CameraManager
			CameraManager.update_main_3d_cam(PCam3D)
			CameraManager.Cam3D = Cam_3D
			
			
			
			
			
			
			#perform an unpack viewport_path
			#the unpack needs to make a 3D node for each 2D character, the 3D mode will use a phantom cam and path setup.
			#var char_node = $"2DCharacters"
			#var flat_chars = char_node.get_children()
			#for char in flat_chars:
				#if char is CharacterBody2D:

		StageMode.DYNAMIC:
			
			print("for future stuff, meant for maps that might need to swap stuff more than once")
		_:
			print("bro really forgot the mode setting, lmao")
