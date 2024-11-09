extends Node

# TODO
# - Preview stroke before submit
# - Remember if stylus is releasing

var preview_stroke : PencilStroke = null
var strokes : Array = []

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	print(event)
	
	match event:
		InputEventScreenTouch:
			if event.pressed:
				create_stroke(event)
			else:
				submit_stroke(event)
		InputEventScreenDrag:
			update_stroke(event)

func create_stroke(event: InputEvent):
	preview_stroke = PencilStroke.new()
	preview_stroke.begin()
	preview_stroke.add_point(event.position)

func update_stroke(event: InputEventScreenDrag):
	preview_stroke.add_point(event.position)

func submit_stroke(event: InputEvent):
	preview_stroke.end()
	
	get_parent().add_child(preview_stroke)
	strokes.append(preview_stroke)
	
	preview_stroke = null


func is_stylus(event: InputEvent) -> bool:
	return not is_nan(event.pressure)
