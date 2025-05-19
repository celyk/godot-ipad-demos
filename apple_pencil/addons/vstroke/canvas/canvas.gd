extends Node

# TODO
# - Preview stroke before submit
# - Remember if stylus is releasing

var preview_stroke : PencilStroke = null
var strokes : Array = []

var allow_touch_to_draw := true

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	#print(event)
	#print("Emulate mouse from touch ", Input.emulate_mouse_from_touch)
	#print("Emulate touch from mouse ", Input.emulate_touch_from_mouse)
	
	#Input.emulate_mouse_from_touch = false
	#Input.emulate_touch_from_mouse = true
	
	if event is InputEventScreenTouch:
			if event.pressed and preview_stroke == null:
				create_stroke(event)
			elif not event.pressed and preview_stroke != null:
				submit_stroke(event)
	elif event is InputEventScreenDrag and preview_stroke != null:
			if allow_touch_to_draw or is_stylus(event):
				update_stroke(event)

var color : Color = Color.WHITE
var min_radius : float = 0.5
var max_radius : float = 4.0
func _process(delta: float) -> void:
	var time := Time.get_ticks_msec() / 1000.0
	#color = get_node("ColorPickerButton").color
	#max_radius = get_node("../../../ColorPickerButton").color
	
	#color = Color.from_hsv(fposmod(time,1.0), 0.4, sin(time)*0.5+0.5)

func create_stroke(event: InputEvent):
	preview_stroke = PencilStroke.new()
	
	preview_stroke.begin()
	#preview_stroke.add_point(_screen_to_local(event.position), color, 0.0)
	
	get_parent().add_child(preview_stroke)

func update_stroke(event: InputEventScreenDrag):
	var width : float = event.pressure
	width = lerp(min_radius, max_radius, width)
	width *= 1.0 / (get_parent().global_transform as Transform2D)[0].length()
	
	#print(width)
	#width = 1.0
	
	preview_stroke.add_point(_screen_to_local(event.position), color, width)

func submit_stroke(event: InputEvent):
	preview_stroke.end()
	
	get_parent().remove_child(preview_stroke)
	get_parent().add_child(preview_stroke)
	strokes.append(preview_stroke)
	
	preview_stroke = null

func _screen_to_local(p:Vector2) -> Vector2:
	return get_parent().make_canvas_position_local(p)

func is_stylus(event: InputEvent) -> bool:
	return not is_nan(event.pressure)
