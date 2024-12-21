extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.use_accumulated_input = false
	#print("screen scale ", DisplayServer.screen_get_scale())
	
	# Fix high DPI on iOS
	if OS.get_name() == "iOS":
		if not Engine.is_editor_hint() and ProjectSettings.get_setting("display/window/dpi/allow_hidpi"):
				get_tree().root.content_scale_factor = 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_m_color_changed(color:Color):
	$canvas_tranformer/Canvas/Script.color = color

func _on_m_value_changed(value:float):
	$canvas_tranformer/Canvas/Script.min_radius = value/8.0
	$canvas_tranformer/Canvas/Script.max_radius = value

func _on_m_toggled(toggled_on: bool) -> void:
	$stylus_debug.visible = toggled_on
