class_name PencilStroke extends Node2D

var points : Array[Vector2] = []
var colors : Array[Color] = []


func begin():
	pass

func add_point(position:Vector2, color:=Color.BLACK, width:=4.0):
	points.append(position)
	colors.append(color)

func end():
	pass

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_multiline_colors(PackedVector2Array(points), PackedColorArray(colors), 3.0, true)
	
	for i in range(0,points.size()):
		pass
