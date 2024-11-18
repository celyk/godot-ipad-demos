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
			if event.pressed and preview_stroke == null:
				create_stroke(event)
			elif not event.pressed and preview_stroke != null:
				submit_stroke(event)
	elif event is InputEventScreenDrag and preview_stroke != null:
			if is_stylus(event):
				update_stroke(event)
			else:
				pass

func create_stroke(event: InputEvent):
	preview_stroke = PencilStroke.new()
	
	preview_stroke.begin()
	preview_stroke.add_point(_screen_to_local(event.position))
	
	get_parent().add_child(preview_stroke)

func update_stroke(event: InputEventScreenDrag):
	preview_stroke.add_point(_screen_to_local(event.position),Color.BLUE_VIOLET,event.pressure*30.0)

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
