class_name PointerPath extends RefCounted

var path : Array = []
var is_stylus := false

func _update(event : InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			path = []
		else:
			#path = []
			pass
	if event is InputEventScreenDrag:
		path.append(event)
		is_stylus = not is_nan(event.pressure)

func _input(event: InputEvent) -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
