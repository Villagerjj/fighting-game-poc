extends Marker3D

@export var targets : Array[Node3D]


func _process(delta: float) -> void:
	var x_positions : Array[float]
	var y_positions : Array[float]
	var z_positions : Array[float]
	
	var average : Vector3 = Vector3(0.0,0.0,0.0)
	
	for char in targets:
		x_positions.append(char.position.x)
		y_positions.append(char.position.y)
		z_positions.append(char.position.z)
	
	var char_count = targets.size()
	
	for char in char_count:
		average.x += x_positions[char]
		average.y += y_positions[char]
		average.z += z_positions[char]
		
		average /= Vector3(char_count, char_count, char_count)
	
	self.position = average
