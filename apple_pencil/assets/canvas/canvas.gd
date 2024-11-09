extends Node

# TODO
# - Preview stroke before submit
# - Remember if stylus is releasing

var preview_stroke : PencilStroke = null
var strokes : Array = []

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
			if event.pressed:
				create_stroke(event)
			else:
				submit_stroke(event)
	elif event is InputEventScreenDrag and preview_stroke != null:
			update_stroke(event)

func create_stroke(event: InputEvent):
	preview_stroke = PencilStroke.new()
	preview_stroke.begin()
	preview_stroke.add_point(_screen_to_world(event.position))

func update_stroke(event: InputEventScreenDrag):
	preview_stroke.add_point(_screen_to_world(event.position))

func submit_stroke(event: InputEvent):
	preview_stroke.end()
	
	get_parent().add_child(preview_stroke)
	strokes.append(preview_stroke)
	
	preview_stroke = null


func _screen_to_world(p:Vector2) -> Vector2:
	return get_parent().make_canvas_position_local(p)
	
	#p = get_viewport().global_canvas_transform.affine_inverse() * p
	#p = get_viewport().get_camera_2d().get_cakera
	
	return p

func is_stylus(event: InputEvent) -> bool:
	return not is_nan(event.pressure)
