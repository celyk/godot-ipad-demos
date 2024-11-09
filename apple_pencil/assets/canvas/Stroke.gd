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
	for i in range(1,points.size()):
		draw_line(points[i-1], points[i], colors[i], 3.0, true)
