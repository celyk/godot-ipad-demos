class_name PencilStrokeRenderer extends MeshInstance2D
# Array of beziers describing a 3D curve. xy is position, z is radius 
var bezier_spline : Array[Array] = []

# Array of colors associated with the end points of each bezier segment
var bezier_spline_color : Array[Color] = []

var mesh_arrays : Array = []

# Todo - apply the heuristic to optimizae the stroke rendering
var heuristic : Callable

func _init() -> void:
	mesh = ArrayMesh.new()
	
	mesh_arrays.resize(ArrayMesh.ARRAY_MAX)
	mesh_arrays[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array()
	#mesh_arrays[Array Mesh.ARRAY_TANGENT] = PackedFloat32Array()
	#mesh_arrays[ArrayMesh.ARRAY_TEX_UV] = PackedVector2Array()
	mesh_arrays[ArrayMesh.ARRAY_COLOR] = PackedColorArray()
	
	#material_override = CanvasItemMaterial.new()
	
	# Add attributes
	# - Width
	# - Color
	# - Tangent



func begin():
	#mesh_arrays = add_circle(mesh_arrays, bezier_spline.front()[0], 10.0, Color.RED)
	
	print(mesh_arrays)

func add_bezier(start:Vector3, control_1:Vector3, control_2:Vector3, end:Vector3):
	bezier_spline.append([start, control_1, control_2, end])
func add_color(start:Color, end:Color):
	bezier_spline_color.append(start)
	bezier_spline_color.append(end)

func end():
	#mesh_arrays = add_circle(mesh_arrays, bezier_spline.front()[0], bezier_spline.front()[0].z, bezier_spline_color.front())
	mesh_arrays = add_circle(mesh_arrays, bezier_spline.back()[3], bezier_spline.back()[3].z, bezier_spline_color.back())
	
	refresh()
	
	print(mesh_arrays)

func _Vector2(p:Vector3) -> Vector2: return Vector2(p.x,p.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func refresh():
	for i in range(0,bezier_spline.size()):
		var arrays := []
		
		
		if mesh.get_surface_count() > 0:
			arrays = mesh.surface_get_arrays(0)
		else:
			arrays.resize(ArrayMesh.ARRAY_MAX)
			
			arrays[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array()
			#arrays[Array Mesh.ARRAY_TANGENT] = PackedFloat32Array()
			#arrays[ArrayMesh.ARRAY_TEX_UV] = PackedVector2Array()
			arrays[ArrayMesh.ARRAY_COLOR] = PackedColorArray()
		
		
		
		var start : Vector3 = (bezier_spline[i][0])
		var control_1 : Vector3 = (bezier_spline[i][1])
		var control_2 : Vector3 = (bezier_spline[i][2])
		var end : Vector3 = (bezier_spline[i][3])
		
		#control_1.z = end.z - start.z
		
		var prev_sub_point = start
		var prev_sub_normal = _Vector2(control_1 - start) * 3
		prev_sub_normal = prev_sub_normal.normalized().rotated(90)
		prev_sub_normal = Vector3(prev_sub_normal.x,prev_sub_normal.y,0)
		var prev_sub_color = bezier_spline_color[i*2+0]
		#prev_sub_color = Color.WHITE
		
		const subdivisions := 10
		for j in range(1, subdivisions+1):
			var t : float = j / float(subdivisions)
			
			var sub_point := start.bezier_interpolate(control_1, control_2, end, t)
			var sub_tangent := start.bezier_derivative(control_1, control_2, end, t)
			
			var sub_normal = _Vector2(sub_tangent)
			sub_normal = sub_normal.normalized().rotated(90)
			sub_normal = Vector3(sub_normal.x,sub_normal.y,0)
			#sub_normal = Vector2(100,0)
			
			var start_color : Color = bezier_spline_color[i*2 + 0]
			var end_color : Color = bezier_spline_color[i*2 + 1]
			
			var sub_color : Color = start_color.lerp(end_color, t)
			
			#arrays[ArrayMesh.ARRAY_VERTEX] += []
			arrays = add_quad(arrays, 
					[prev_sub_point + prev_sub_normal * prev_sub_point.z, 
					prev_sub_point - prev_sub_normal * prev_sub_point.z, 
					sub_point - sub_normal * sub_point.z, 
					sub_point + sub_normal * sub_point.z],
					[prev_sub_color, prev_sub_color, sub_color, sub_color])
			
			#print(arrays)
			
			prev_sub_point = sub_point
			prev_sub_normal = sub_normal
			prev_sub_color = sub_color
		
		mesh.clear_surfaces()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		
		if mesh_arrays[ArrayMesh.ARRAY_VERTEX]: 
			mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)


func add_quad(arrays:Array, quad_vertices:Array, quad_colors:Array):
	# ABC - 012
	arrays[ArrayMesh.ARRAY_VERTEX] += PackedVector3Array([quad_vertices[0]])
	arrays[ArrayMesh.ARRAY_COLOR] += PackedColorArray([quad_colors[0]])
	arrays[ArrayMesh.ARRAY_VERTEX] += PackedVector3Array([quad_vertices[1]])
	arrays[ArrayMesh.ARRAY_COLOR] += PackedColorArray([quad_colors[1]])
	arrays[ArrayMesh.ARRAY_VERTEX] += PackedVector3Array([quad_vertices[2]])
	arrays[ArrayMesh.ARRAY_COLOR] += PackedColorArray([quad_colors[2]])
	
	# ACD - 023
	arrays[ArrayMesh.ARRAY_VERTEX] += PackedVector3Array([quad_vertices[0]])
	arrays[ArrayMesh.ARRAY_COLOR] += PackedColorArray([quad_colors[0]])
	arrays[ArrayMesh.ARRAY_VERTEX] += PackedVector3Array([quad_vertices[2]])
	arrays[ArrayMesh.ARRAY_COLOR] += PackedColorArray([quad_colors[2]])
	arrays[ArrayMesh.ARRAY_VERTEX] += PackedVector3Array([quad_vertices[3]])
	arrays[ArrayMesh.ARRAY_COLOR] += PackedColorArray([quad_colors[3]])
	
	return arrays

func add_circle(arrays:Array, p:Vector3, radius:float, color:Color, steps:=16):
	var prev_v := radius * Vector3(cos(0), sin(0), 0)
	for i in range(1,steps):
		var t : float = TAU * float(i) / float(steps-1)
		var v := radius * Vector3(cos(t), sin(t), 0)
		
		arrays[ArrayMesh.ARRAY_VERTEX] += PackedVector3Array([p, p + prev_v, p + v])
		arrays[ArrayMesh.ARRAY_COLOR] += PackedColorArray([color, color, color])
		
		prev_v = v
	
	return arrays
