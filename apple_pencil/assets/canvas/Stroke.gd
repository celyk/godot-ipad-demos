class_name PencilStroke extends Node2D

var bezier_spline : Array[Array] = []
var bezier_spline_width : Array[float] = []
var bezier_spline_color : Array[Color] = []


var stroke_renderer := PencilStrokeRenderer.new()
func begin():
	add_child(stroke_renderer)
	
	pass

func add_point(position:Vector2, color:=Color.BLACK, width:=4.0):
	var prev_position = position
	if bezier_spline:
		prev_position = bezier_spline.back()[3]
	
	add_bezier(prev_position, prev_position, position, position)
	bezier_spline_width += [width]
	bezier_spline_color += [color]
	
	queue_redraw()
	smooth()
	
	''''var start : Vector2 = (bezier_spline.back()[0])
	var control_1 : Vector2 = (bezier_spline.back()[1])
	var control_2 : Vector2 = (bezier_spline.back()[2])
	var end : Vector2 = (bezier_spline.back()[3])
	
	var start_width : float = bezier_spline_width[max(bezier_spline_width.size()-2,0)]
	var end_width : float = bezier_spline_width.back()
		
	stroke_renderer.add_bezier(
			Vector3(start.x,start.y,start_width), 
			Vector3(control_1.x,control_1.y,0),
			Vector3(control_2.x,control_2.y,0), 
			Vector3(end.x,end.y,end_width) )
	
	stroke_renderer.refresh()'''
	
	render_b(bezier_spline.size()-2)
	
	stroke_renderer.refresh()
	
	#end()

func add_bezier(start:Vector2, control_1:Vector2, control_2:Vector2, end:Vector2):
	bezier_spline.append([start, control_1, control_2, end])


func render_b(i:int):
	var start : Vector2 = (bezier_spline[i][0])
	var control_1 : Vector2 = (bezier_spline[i][1])
	var control_2 : Vector2 = (bezier_spline[i][2])
	var end : Vector2 = (bezier_spline[i][3])
		
	var end_width : float = bezier_spline_width[ min(i+1,bezier_spline.size()-1) ]
		
	stroke_renderer.add_bezier(
			Vector3(start.x,start.y,bezier_spline_width[i]), 
			Vector3(control_1.x,control_1.y,0),
			Vector3(control_2.x,control_2.y,0), 
			Vector3(end.x,end.y,end_width) )

func end():
	#smooth()
	
	for i in range(bezier_spline.size()-1,bezier_spline.size()):
		render_b(i)
	
	stroke_renderer.refresh()

func smooth():
	for i in range(1, bezier_spline.size()):
		var a : Vector2 = bezier_spline[i-1][0]
		var b : Vector2 = bezier_spline[i][0]
		var c : Vector2 = bezier_spline[i][3]
		
		# Approximate derivative using secant
		var slope := (c-a) / 2.0
		
		# Apply formula to compute control point from velocity and set the neighbouring control points
		bezier_spline[i-1][2] = b-slope / 3.0
		bezier_spline[i][1] = b+slope / 3.0
	
	queue_redraw()

#func _process(delta:float) -> void:
#	queue_redraw()=

func _draw() -> void:
	return
	
	for i in range(1, bezier_spline.size()):
		var start : Vector2 = (bezier_spline[i][0])
		var control_1 : Vector2 = (bezier_spline[i][1])
		var control_2 : Vector2 = (bezier_spline[i][2])
		var end : Vector2 = (bezier_spline[i][3])
		
		var prev_sub_point = start
		const subdivisions := 2
		for j in range(1, subdivisions+1):
			var t : float = j / float(subdivisions)
			
			var sub_point := start.bezier_interpolate(control_1, control_2, end, t)
			draw_line(prev_sub_point, sub_point, Color.SKY_BLUE, 1.0, true)
			
			prev_sub_point = sub_point
