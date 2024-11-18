extends Node2D

func canvas_to_global_position(p : Vector2) -> Vector2:
	var parent = get_parent()
	return get_viewport().canvas_transform.affine_inverse() * p

func get_actual_tilt_vector(tilt : Vector2, windows := true) -> Vector3:
	windows = (OS.get_name() == "Windows")
	
	if windows:
		return Vector3(tan(tilt.x), tan(tilt.y), 1).normalized()
	
	return Vector3( tilt.x, tilt.y, sqrt(1.0 - tilt.dot(tilt)) )

var noise := FastNoiseLite.new()

func randv(seed=0):
	var result : Vector4
	
	for i in range(0,4):
		noise.seed = seed + i
		result[i] = noise.get_noise_1d(40.0 * Time.get_ticks_msec() / 1000.0)
	
	return result

func _input(event):
	if event is InputEventMouseMotion:
		global_position = canvas_to_global_position( event.position )
		
		var tilt : Vector3 = get_actual_tilt_vector(event.tilt)
		#global_transform = global_transform * Transform3D(Basis(),Vector3())
		scale = Vector2(1,1)
		scale.x = 1.0 + 4.8 * tilt.slide(Vector3(0,0,1)).length()
		
		rotation = Vector2(tilt.x,tilt.y).angle()
		
		#scale.y = 1.0 + 4.0*abs(tilt.y)
		scale *= lerp(0.01,1.0,event.pressure)
		
		var rv : Vector4 = randv()
		#rv = rv * 0.7 + Vector4.ONE * 0.3
		modulate = Color.from_hsv(0.1 * Time.get_ticks_msec() / 1000.0,1,1)
