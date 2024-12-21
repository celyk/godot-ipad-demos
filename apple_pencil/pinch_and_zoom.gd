#extends Camera2D
extends Node2D

var center := Vector2(0,0)

var touch_events : Array = []

var prev_touch_events : Array = []

func _ready():
	# 10 touches for 10 fingers
	touch_events.resize(10)
	prev_touch_events.resize(10)

func _input(event: InputEvent) -> void:
	if event is InputEventPanGesture:
		#global_transform = Transform2D().translated(_screen_to_local(event.relative)-_screen_to_local(Vector2(0,0)))
		global_position += -event.delta # * global_transform[0].length()
	if event is InputEventScreenDrag and not is_stylus(event):
		global_position += event.relative
	if event is InputEventMagnifyGesture:
		var p : Vector2 = _screen_to_local(event.position)
		global_transform = Transform2D().translated(-p) * global_transform
		global_transform = Transform2D().scaled(Vector2.ONE*event.factor) * global_transform
		global_transform = Transform2D().translated(p) * global_transform
	
	if event is InputEventMouseMotion:
		if Input.get_mouse_button_mask() & MOUSE_BUTTON_MASK_MIDDLE:
			global_position += event.relative 
	if event is InputEventMouseButton:
		var p : Vector2 = _screen_to_local(event.position)
		var rate := 0.04
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			global_transform = Transform2D().translated(-p) * global_transform
			global_transform = Transform2D().scaled(Vector2.ONE * (1.0 + event.factor * rate)) * global_transform
			global_transform = Transform2D().translated(p) * global_transform
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			global_transform = Transform2D().translated(-p) * global_transform
			global_transform = Transform2D().scaled(Vector2.ONE / (1.0 + event.factor * rate)) * global_transform
			global_transform = Transform2D().translated(p) * global_transform

func _process0(delta: float) -> void:
	#print(prev_touch_events)
	
	# The first 2 touches are dragging
	if prev_touch_events[0] and prev_touch_events[1] and touch_events[0] and touch_events[1]:
		global_transform = _get_pinch_transform(
				_screen_to_local(prev_touch_events[0].position), 
				_screen_to_local(prev_touch_events[1].position),
				_screen_to_local(touch_events[0].position), 
				_screen_to_local(touch_events[1].position)) * global_transform
	elif prev_touch_events[0] and touch_events[0]:
		global_position += touch_events[0].relative
	
	prev_touch_events = touch_events.duplicate(true)
	
	# Clear the touches so that they can be null in next frame
	#for i in range(0,touch_events.size()): 
		#touch_events[i] = null

# This is a transformation which takes line (from_a,from_b) to line (to_a,to_b)
func _get_pinch_transform(from_a : Vector2, from_b : Vector2, to_a : Vector2, to_b : Vector2) -> Transform2D:
	return (_get_line_transform(to_a, to_b) * _get_line_transform(from_a, from_b).affine_inverse())

func _get_line_transform(a : Vector2, b : Vector2):
	return Transform2D(b-a, Vector2(-(b.y-a.y), b.x-a.x), a)

func _screen_to_local(p:Vector2) -> Vector2:
	return get_parent().make_canvas_position_local(p)

func is_stylus(event: InputEvent) -> bool:
	return not is_nan(event.pressure)
