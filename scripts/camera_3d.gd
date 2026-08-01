extends Camera3D

@onready var phantom_camera_2d : PhantomCamera2D = get_node("/root/Main/PhantomCamera2D")
@onready var camera_2d : Camera2D = get_node("/root/Main/GameCam")
@onready var screen_size = Global.SCREEN_SIZE  # Resolution, e.g., 1280x960
@onready var viewport = get_node("../..")
#@onready var DEBUG_BOX = get_node("../CSGBox3D")

const DISTANCE_FROM_STAGE_METERS = 3.0
const PIXELS_PER_METER = Global.PIXELS_PER_METER

func _ready() -> void:
	while phantom_camera_2d == null:
		await get_tree().process_frame

	#DEBUG_BOX.position.z = -DISTANCE_FROM_STAGE_METERS

func _process(_delta: float) -> void:
	# Convert visible screen height (in pixels) into world height (in meters)
	var zoom_y = phantom_camera_2d.zoom.y
	var visible_world_height_meters = (screen_size.y * zoom_y) / PIXELS_PER_METER

	# Compute vertical FOV from zoom and distance
	var fov_rad = 2.0 * atan((visible_world_height_meters / 4.0) / DISTANCE_FROM_STAGE_METERS)
	fov = clamp(rad_to_deg(fov_rad), 1.0, 179.0)

	# Sync 3D camera position with 2D camera
	position.x = camera_2d.global_position.x / PIXELS_PER_METER
	position.y = -camera_2d.global_position.y / PIXELS_PER_METER
	position.z = DISTANCE_FROM_STAGE_METERS

	# Update debug box position
	#DEBUG_BOX.position.x = position.x
	#DEBUG_BOX.position.y = position.y + 0.5  # Offset so box appears above ground plane
