class_name PencilStrokeRenderer extends MeshInstance2D

var bezier_spline : Array[Array] = []
var colors : Array[Color] = []

# Todo - apply the hueristic to optimizae the stroke rendering
var heuristic : Callable

func _init() -> void:
	mesh = ArrayMesh.new()
	
	#material_override = CanvasItemMaterial.new()
	
	# Add attributes
	# - Width
	# - Color
	# - Tangent



func begin():
	pass

func add_bezier(start:Vector3, control_1:Vector3, control_2:Vector3, end:Vector3):
	bezier_spline.append([start, control_1, control_2, end])

func end():
	refresh()

func _Vector2(p:Vector3) -> Vector2: return Vector2(p.x,p.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func refresh():
	for i in range(0,bezier_spline.size()):
		var arrays = []
		
		
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
		
		const subdivisions := 5
		for j in range(1, subdivisions+1):
			var t : float = j / float(subdivisions)
			
		
			var sub_point := start.bezier_interpolate(control_1, control_2, end, t)
			#sub_point.z = (start.lerp(end,t)).z
			var sub_tangent := start.bezier_derivative(control_1, control_2, end, t)
			
			var sub_normal = _Vector2(sub_tangent)
			sub_normal = sub_normal.normalized().rotated(90)
			sub_normal = Vector3(sub_normal.x,sub_normal.y,0)
			#sub_normal = Vector2(100,0)
			
			#arrays[ArrayMesh.ARRAY_VERTEX] += []
			arrays = add_quad(arrays, 
					[prev_sub_point + prev_sub_normal * prev_sub_point.z, 
					prev_sub_point - prev_sub_normal * prev_sub_point.z, 
					sub_point - sub_normal * sub_point.z, 
					sub_point + sub_normal * sub_point.z],
					[Color.BLACK,Color.BLACK,Color.BLACK,Color.BLACK])
			
			#print(arrays)
			
			prev_sub_point = sub_point
			prev_sub_normal = sub_normal
		
		mesh.clear_surfaces()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)


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
	
