#extends Camera2D
extends Node2D

var center := Vector2(0,0)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:# and not is_stylus(event):
		#if event.index == 0: event.index = 1
		
		if event.index == 0:
			center = event.position
			global_position -= event.relative
		if event.index == 1:
			global_transform = _get_pinch_transform(
				_screen_to_local(center), 
				_screen_to_local(event.position-event.relative), 
				_screen_to_local(center), 
				_screen_to_local(event.position)) * global_transform

# This is a transformation which takes line (from_a,from_b) to line (to_a,to_b)
func _get_pinch_transform(from_a : Vector2, from_b : Vector2, to_a : Vector2, to_b : Vector2) -> Transform2D:
	return (_get_line_transform(to_a, to_b) * _get_line_transform(from_a, from_b).affine_inverse())

func _get_line_transform(a : Vector2, b : Vector2):
	return Transform2D(b-a, Vector2(-(b.y-a.y), b.x-a.x), a)

func _screen_to_local(p:Vector2) -> Vector2:
	return get_parent().make_canvas_position_local(p)

func is_stylus(event: InputEvent) -> bool:
	return not is_nan(event.pressure)
