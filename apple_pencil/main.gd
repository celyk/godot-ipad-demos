extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.use_accumulated_input = false
	#print("screen scale ", DisplayServer.screen_get_scale())
	
	if not Engine.is_editor_hint() and not ProjectSettings.get_setting("display/window/dpi/allow_hidpi"):
		ProjectSettings.set_setting(
				"display/window/stretch/scale", 
				ProjectSettings.get_setting("display/window/stretch/scale") * 2.0)
		#DisplayServer.scale
		print("hiya")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_m_color_changed(color:Color):
	$canvas_tranformer/Canvas/Script.color = color

func _on_m_value_changed(value:float):
	$canvas_tranformer/Canvas/Script.max_radius = value

func _on_m_toggled(toggled_on: bool) -> void:
	$stylus_debug.visible = toggled_on
