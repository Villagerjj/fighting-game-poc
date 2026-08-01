extends Camera2D
@export_category("Multi Target Camera")
@export var move_speed = 0.5  # Camera position lerp speed
@export var zoom_speed = 0.25  # Camera zoom lerp speed
@export var min_zoom = 1.5  # Minimum zoom level
@export var max_zoom = 5.0  # Maximum zoom level
@export var margin = Vector2(400, 200)  # Buffer area around targets

var targets = []  # Array of targets to be tracked.

@export_category("Camera Shake")
@export var def_period = 0.3
@export var def_magnitude = 0.4



@onready var screen_size = get_viewport_rect().size



func _ready() -> void:
	randomize()
	SignalBus.add_trauma.connect(_camera_shake)



func _process(_delta):
	if targets.size() == 0:
		return

	# Calculate the bounding rectangle for all targets
	var bounds = Rect2(targets[0].position, Vector2.ZERO)

	for target in targets:
		bounds = bounds.expand(target.position)

	# Expand the bounds with the margin
	bounds = bounds.grow_individual(margin.x, margin.y, margin.x, margin.y)

	# Center the camera on the bounds
	position = lerp(position, bounds.position + bounds.size / 2, move_speed)

	# Calculate the zoom level that will contain all targets
#	var aspect_ratio = screen_size.x / screen_size.y
	var zoom_factor = max(bounds.size.x / screen_size.x, bounds.size.y / screen_size.y)

	# Clamp the zoom factor to the defined min and max zoom levels
	var target_zoom = clamp(zoom_factor, min_zoom, max_zoom)

	# Lerp the camera zoom
	zoom.x = lerp(zoom.x, target_zoom, zoom_speed)
	zoom.y = lerp(zoom.y, target_zoom, zoom_speed)
	

func _camera_shake(magnitude : float = def_magnitude, period : float = def_period):
	var initial_offset = self.offset
	var elapsed_time = 0.0
	var cam_offset : Vector2
	var old_cam_offset : Vector2 = Vector2(0,0)
	
	while elapsed_time < period:
		old_cam_offset = cam_offset
		cam_offset.x = lerpf(old_cam_offset.x, randf_range(-magnitude, magnitude), 0.5)
		cam_offset.y = lerpf(old_cam_offset.y, randf_range(-magnitude, magnitude), 0.5)
		self.offset = cam_offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame
	
	self.offset = initial_offset
	#self.transform = initial_transform

#func shake(delta: float):
	## Calculate the trauma amount using a power curve for intensity
	#var amount = pow(trauma, trauma_power)
	#
	## Increment noise_y by a time factor for smoother and more consistent noise
	#noise_y += delta * 10  # Increase the multiplier for faster noise transitions if needed
	#
	## Generate smooth perlin noise for camera rotation and offset
	#rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	#offset.x = lerp(offset.x, max_offset.x * amount * noise.get_noise_2d(noise.seed + 1, noise_y), 0.1)
	#offset.y = lerp(offset.y, max_offset.y * amount * noise.get_noise_2d(noise.seed + 2, noise_y), 0.1)
	
	# Apply the offset and rotation to the camera
	#global_position += offset
	#rotation_degrees += rotation

#func shake(delta : float):
	#var amount = pow(trauma, trauma_power)
	#noise_y += 1 * delta
	#rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	#offset.x = lerpf(offset.x, max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y), delta)
	#offset.y = lerpf(offset.y, max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y), delta)

#func shake():
	## Cache the shake amount
	#var amount = pow(trauma, trauma_power)
	#
	## Increment noise position or seed for variation
	#noise_y += 0.1  # or some small increment for smoother shake
	#
	## Cache noise results for the frame
	#var noise_x = noise.get_noise_2d(noise.seed * 2, noise_y)
	#var noise_y_value = noise.get_noise_2d(noise.seed * 3, noise_y)
	#var noise_rotation = noise.get_noise_2d(noise.seed, noise_y)
	#
	## Apply shake
	#offset.x = max_offset.x * amount * noise_x
	#offset.y = max_offset.y * amount * noise_y_value
	#rotation = max_roll * amount * noise_rotation

func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.erase(t)


#extends Camera2D
#
#@export var move_speed = 0.5  # camera position lerp speed
#@export var zoom_speed = 0.25  # camera zoom lerp speed
#@export var min_zoom = 1.5  # camera won't zoom closer than this
#@export var max_zoom = 5  # camera won't zoom farther than t5his
#@export var margin = Vector2(400, 200)  # include some buffer area around targets
#
#var targets = []  # Array of targets to be tracked.
#
#@onready var screen_size = get_viewport_rect().size
#
#func _process(_delta):
	#if !targets:
		#return
	## Keep the camera centered between the targets
	#var p = Vector2.ZERO
	#for target in targets:
		#p += target.position
	#p /= targets.size()
	#position = lerp(position, p, move_speed)
	## Find the zoom that will contain all targets
	#var r = Rect2(position, Vector2.ONE)
	#for target in targets:
		#r = r.expand(target.position)
	#r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	##var d = max(r.size.x, r.size.y)
	#var z
	#if r.size.x > r.size.y * screen_size.aspect():
		#z = clamp(r.size.x / screen_size.x, min_zoom, max_zoom)
	#else:
		#z = clamp(r.size.y / screen_size.y, min_zoom, max_zoom)
	#zoom = lerp(zoom, Vector2.ONE * z, zoom_speed)
#
#func add_target(t):
	#if not t in targets:
		#targets.append(t)
#
#func remove_target(t):
	#if t in targets:
		#targets.erase(t)

#extends Camera2D
#
#@export var move_speed: float = 0.5  # Camera position lerp speed
#@export var zoom_speed: float = 0.25  # Camera zoom lerp speed
#@export var min_zoom: float = -1.0  # Minimum zoom level
#@export var default_zoom: float = 1.5  # Default zoom level
#@export var max_zoom: float = 5.0  # Maximum zoom level
#@export var margin: Vector2 = Vector2(400, 200)  # Buffer area around targets
#
#var targets: Array = []  # Array of targets to track
#@onready var screen_size: Vector2 = get_viewport_rect().size
#
#func _process(_delta: float) -> void:
	#if targets.is_empty():
		#return
#
	## Calculate the average position of targets
	#var average_position: Vector2 = Vector2.ZERO
	#for target in targets:
		#average_position += target.position
	#average_position /= targets.size()
#
	## Lerp camera position to the average target position
	#position = position.lerp(average_position, move_speed)
#
	## Create a bounding rectangle around targets
	#var bounding_rect: Rect2 = Rect2(average_position, Vector2.ZERO)
	#for target in targets:
		#bounding_rect = bounding_rect.expand(target.position)
#
	## Grow the bounding rectangle by the margin using individual values
	#bounding_rect.grow_individual(margin.x, margin.y, margin.x, margin.y)
#
	## Calculate the zoom factor based on the bounding rectangle
	#var zoom_factor: float
	#if bounding_rect.size.x > bounding_rect.size.y * screen_size.aspect():
		#zoom_factor = bounding_rect.size.x / screen_size.x
	#else:
		#zoom_factor = bounding_rect.size.y / screen_size.y
#
	## Clamp zoom_factor between min_zoom and max_zoom
	#zoom_factor = clamp(zoom_factor, min_zoom, max_zoom)
#
	## If zoom_factor is greater than the default zoom, adjust it
	#if zoom_factor > default_zoom:
		#zoom = zoom.lerp(Vector2.ONE * zoom_factor, zoom_speed)
	#else:
		#zoom = zoom.lerp(Vector2.ONE * default_zoom, zoom_speed)
#
#func add_target(t: Node) -> void:
	#if not t in targets:
		#targets.append(t)
#
#func remove_target(t: Node) -> void:
	#if t in targets:
		#targets.erase(t)



#extends Camera2D
#
#@export var move_speed: float = 0.5  # Camera position lerp speed
#@export var zoom_speed: float = 0.25  # Camera zoom lerp speed
#@export var min_zoom: float = -1.0  # Minimum zoom level
#@export var default_zoom: float = 1.5  # Default zoom level
#@export var max_zoom: float = 5.0  # Maximum zoom level
#@export var margin: Vector2 = Vector2(400, 200)  # Buffer area around targets
#
#var targets: Array = []  # Array of targets to track
#@onready var screen_size: Vector2 = get_viewport_rect().size
#
#func _process(_delta: float) -> void:
	#if targets.is_empty():
		#return
#
	## Calculate the average position of targets
	#var average_position: Vector2 = Vector2.ZERO
	#for target in targets:
		#average_position += target.position
	#average_position /= targets.size()
#
	## Lerp camera position to the average target position
	#position = position.lerp(average_position, move_speed)
#
	## Create a bounding rectangle around targets
	#var bounding_rect: Rect2 = Rect2(average_position, Vector2.ZERO)
	#for target in targets:
		#bounding_rect = bounding_rect.expand(target.position)
#
	## Grow the bounding rectangle by the margin using individual values
	#bounding_rect.grow_individual(margin.x, margin.y, margin.x, margin.y)
#
	## Calculate zoom based on the bounding rectangle
	#var zoom_factor: float
	#if bounding_rect.size.x > bounding_rect.size.y * screen_size.aspect():
		#zoom_factor = clamp(bounding_rect.size.x / screen_size.x, min_zoom, max_zoom)
	#else:
		#zoom_factor = clamp(bounding_rect.size.y / screen_size.y, min_zoom, max_zoom)
#
	## Use the default zoom as the starting point
	#var target_zoom = zoom_factor
	#if target_zoom < default_zoom:
		#target_zoom = default_zoom  # Don't zoom closer than default
#
	## Lerp zoom to the new zoom factor
	#zoom = zoom.lerp(Vector2.ONE * target_zoom, zoom_speed)
#
#func add_target(t: Node) -> void:
	#if not t in targets:
		#targets.append(t)
#
#func remove_target(t: Node) -> void:
	#if t in targets:
		#targets.erase(t)


#extends Camera2D
#
#@export var move_speed: float = 0.5  # Camera position lerp speed
#@export var zoom_speed: float = 0.25  # Camera zoom lerp speed
#@export var min_zoom: float = 1.5  # Minimum zoom level
#@export var max_zoom: float = 5.0  # Maximum zoom level
#@export var margin: Vector2 = Vector2(400, 200)  # Buffer area around targets
#
#var targets: Array = []  # Array of targets to track
#@onready var screen_size: Vector2 = get_viewport_rect().size
#
#func _process(_delta: float) -> void:
	#if targets.is_empty():
		#return
#
	## Calculate the average position of targets
	#var average_position: Vector2 = Vector2.ZERO
	#for target in targets:
		#average_position += target.position
	#average_position /= targets.size()
#
	## Lerp camera position to the average target position
	#position = position.lerp(average_position, move_speed)
#
	## Create a bounding rectangle around targets
	#var bounding_rect: Rect2 = Rect2(average_position, Vector2.ZERO)
	#for target in targets:
		#bounding_rect = bounding_rect.expand(target.position)
#
	## Grow the bounding rectangle by the margin using individual values
	#bounding_rect.grow_individual(margin.x, margin.y, margin.x, margin.y)
#
	## Debug output
	#print("Bounding Rect:", bounding_rect)
#
	## Calculate zoom based on the aspect ratio
	#var zoom_factor: float
	#if bounding_rect.size.x > bounding_rect.size.y * screen_size.aspect():
		#zoom_factor = clamp(bounding_rect.size.x / screen_size.x, min_zoom, max_zoom)
	#else:
		#zoom_factor = clamp(bounding_rect.size.y / screen_size.y, min_zoom, max_zoom)
#
	#print("Zoom Factor:", zoom_factor)
#
	## Lerp zoom to the new zoom factor
	#zoom = zoom.lerp(Vector2.ONE * zoom_factor, zoom_speed)
#
##func _process(_delta: float) -> void:
	##if targets.is_empty():
		##return
##
	### Calculate the average position of targets
	##var average_position: Vector2 = Vector2.ZERO
	##for target in targets:
		##average_position += target.position
	##average_position /= targets.size()
##
	### Lerp camera position to the average target position
	##position = position.lerp(average_position, move_speed)
##
	### Create a bounding rectangle around targets
	##var bounding_rect: Rect2 = Rect2(average_position, Vector2.ZERO)
	##for target in targets:
		##bounding_rect = bounding_rect.expand(target.position)
##
	### Grow the bounding rectangle by the margin
	##bounding_rect.grow_individual(margin.x, margin.y, margin.x, margin.y)
##
	### Calculate zoom based on the aspect ratio
	##var zoom_factor: float
	##if bounding_rect.size.x > bounding_rect.size.y * screen_size.aspect():
		##zoom_factor = clamp(bounding_rect.size.x / screen_size.x, min_zoom, max_zoom)
	##else:
		##zoom_factor = clamp(bounding_rect.size.y / screen_size.y, min_zoom, max_zoom)
##
	### Lerp zoom to the new zoom factor
	##zoom = zoom.lerp(Vector2.ONE * zoom_factor, zoom_speed)
##
#
#func add_target(t: Node) -> void:
	#if not t in targets:
		#targets.append(t)
#
#func remove_target(t: Node) -> void:
	#if t in targets:
		#targets.erase(t)

#
