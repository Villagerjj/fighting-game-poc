extends Camera3D

@onready var camera_2d : PhantomCamera2D = get_node("/root/Main/PhantomCamera2D")
@onready var screen_size = get_node(".").get_viewport().size
@onready var viewport = get_node("../..")
@onready var DEBUG_BOX = get_node("../CSGBox3D")
var distance_from_stage = 420.0 / Global._2d_to_3d_scale

#var viewport = get_viewport().size
var horizontal_fov : float
var aspect_ratio
var z_position
# Set the camera FOV and position
func _ready() -> void:
	while camera_2d == null:
		pass
	#aspect_ratio = viewport.get_viewport().size.x / viewport.get_viewport().size.y
	#z_position = (aspect_ratio * Global._2d_to_3d_scale) / (2.0 * tan(fov / 2.0))
	#horizontal_fov = deg_to_rad(2 * (atan((viewport.size.x / Global._2d_to_3d_scale) / (2 * (distance_from_stage)))))
	position.z = distance_from_stage  # Control depth for 3D view
	#fov = clamp(horizontal_fov, 1, 179)
	print(viewport.size.x)
	
	DEBUG_BOX.position.z = -distance_from_stage

func _process(_delta: float) -> void:
	# Sync the 2D camera's position with the 3D camera, but apply perspective.
	viewport.size = Vector2(screen_size) / camera_2d.zoom 
	viewport.position = -(viewport.size/2)
	horizontal_fov = atan(viewport.size.x / distance_from_stage) # 2 * deg_to_rad(atan((viewport.size.x / Global._2d_to_3d_scale) / (2 * (distance_from_stage / Global._2d_to_3d_scale))))
	fov = clamp(rad_to_deg(horizontal_fov ), 1, 179)
	#print(horizontal_fov)
	#print(fov)
	position.x = camera_2d.global_position.x / Global._2d_to_3d_scale
	position.y = -(camera_2d.global_position.y / Global._2d_to_3d_scale)
	
	
	DEBUG_BOX.position.x = camera_2d.global_position.x / Global._2d_to_3d_scale
	DEBUG_BOX.position.y = -(camera_2d.global_position.y / Global._2d_to_3d_scale) + 0.5
	
