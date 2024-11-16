class_name PencilStroke extends Node2D

var bezier_spline : Array[Vector2] = []
var colors : Array[Color] = []


func begin():
	pass

func add_point(position:Vector2, color:=Color.BLACK, width:=4.0):
	var prev_position = position
	if bezier_spline:
		prev_position = bezier_spline.back()
	
	add_bezier(prev_position, prev_position, position, position)
	colors.append(color)
	
	queue_redraw()

func add_bezier(start:Vector2, control_1:Vector2, control_2:Vector2, end:Vector2):
	bezier_spline += [start, control_1, control_2, end]

func end():
	smooth()

func smooth():
	for i in range(1, bezier_spline.size()/4):
		var a : Vector2 = bezier_spline[i*4-4]
		var b : Vector2 = bezier_spline[i*4]
		var c : Vector2 = bezier_spline[i*4+3]
		
		# Approximate derivative using secant
		var slope := (c-a) / 2.0
		
		# Apply formula to compute control point from velocity and set the neighbouring control points
		bezier_spline[i*4-2] = b-slope / 3.0
		bezier_spline[i*4+1] = b+slope / 3.0
	
	queue_redraw()

#func _process(delta:float) -> void:
#	queue_redraw()

func _draw() -> void:
	for i in range(1, bezier_spline.size()/4):
		var start : Vector2 = bezier_spline[i*4-4]
		var control_1 : Vector2 = bezier_spline[i*4-3]
		var control_2 : Vector2 = bezier_spline[i*4-2]
		var end : Vector2 = bezier_spline[i*4-1]
		
		var pre_sub_point = start
		const subdivisions := 15
		for j in range(1, subdivisions+1):
			var t : float = j / float(subdivisions)
			
			var sub_point := start.bezier_interpolate(control_1, control_2, end, t)
			draw_line(pre_sub_point, sub_point, colors[i], 1.0, true)
			
			pre_sub_point = sub_point
