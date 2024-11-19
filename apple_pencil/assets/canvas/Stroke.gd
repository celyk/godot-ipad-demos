class_name PencilStroke extends Node2D

# Array of beziers describing a 3D curve. xy is position, z is radius 
var bezier_spline : Array[Array] = []

# Array of colors associated with the end points of each bezier segment
var bezier_spline_color : Array[Color] = []

# The stroke renderer is responsible for rasterizing the spline
var stroke_renderer := PencilStrokeRenderer.new()
func begin():
	# Add the stroke renderer to the SceneTree so that it can process. Might change later
	add_child(stroke_renderer)
	stroke_renderer.begin()

func add_point(position:Vector2, color:=Color.BLACK, width:=4.0):
	# Let the previous position be the current position at the beginning 
	var prev_position = Vector3(position.x, position.y, width)
	
	# If the spline contains any segments, set the previous position to the known endpoint
	if bezier_spline:
		prev_position = bezier_spline.back()[3]
	
	add_bezier(prev_position, prev_position, Vector3(position.x, position.y, width), Vector3(position.x, position.y, width))
	
	if bezier_spline_color.size() == 0:
		bezier_spline_color += [color]
	bezier_spline_color += [color]
	
	# Smooth out the spline so that it passes through each point
	smooth()
	
	# Add the latest piece to the stroke renderer
	render_b(bezier_spline.size()-2)
	stroke_renderer.add_color(bezier_spline_color[bezier_spline_color.size()-2], color)
	
	# Give the renderer a chance to update given the new information
	#stroke_renderer.refresh()

func add_bezier(start:Vector3, control_1:Vector3, control_2:Vector3, end:Vector3):
	bezier_spline.append([start, control_1, control_2, end])


func render_b(i:int):
	var start : Vector3 = (bezier_spline[i][0])
	var control_1 : Vector3 = (bezier_spline[i][1])
	var control_2 : Vector3 = (bezier_spline[i][2])
	var end : Vector3 = (bezier_spline[i][3])
	stroke_renderer.add_bezier(start, control_1, control_2, end)
	#stroke_renderer.add_color()

func end():
	#smooth()
	
	#for i in range(bezier_spline.size()-1,bezier_spline.size()):
	#	render_b(i)
	
	stroke_renderer.end()
	#stroke_renderer.refresh()

func smooth():
	for i in range(1, bezier_spline.size()):
		var a : Vector3 = bezier_spline[i-1][0]
		var b : Vector3 = bezier_spline[i][0]
		var c : Vector3 = bezier_spline[i][3]
		
		# Approximate derivative using secant
		var slope := (c-a) / 2.0
		
		# Apply formula to compute control point from velocity and set the neighbouring control points
		bezier_spline[i-1][2] = b-slope / 3.0
		bezier_spline[i][1] = b+slope / 3.0
