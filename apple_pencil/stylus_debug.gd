extends Node2D

var stylus_event : InputEvent = null

func _get_actual_tilt_vector(tilt : Vector2, windows := true) -> Vector3:
	windows = (OS.get_name() == "Windows")
	
	if windows:
		return Vector3(tan(tilt.x), tan(tilt.y), 1).normalized()
	
	return Vector3( tilt.x, tilt.y, sqrt(1.0 - tilt.dot(tilt)) )

func _input(event: InputEvent) -> void:
	if (event is InputEventScreenDrag) and is_stylus(event):
		stylus_event = event

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if stylus_event != null:
		var n : Vector3 = _get_actual_tilt_vector(stylus_event.tilt)
		draw_line(
				_screen_to_local(stylus_event.position),
				_screen_to_local(stylus_event.position + 200*Vector2(n.x,n.y)),
				Color.GREEN, 3.0, true)
	stylus_event = null

func is_stylus(event: InputEvent) -> bool:
	return not is_nan(event.pressure)

func _screen_to_local(p:Vector2) -> Vector2:
	return make_canvas_position_local(p)