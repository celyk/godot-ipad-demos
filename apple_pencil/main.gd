extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_m_color_changed(color:Color):
	$canvas_tranformer/Canvas/Script.color = color

func _on_m_value_changed(value:float):
	$canvas_tranformer/Canvas/Script.max_radius = value

func _on_m_toggled(toggled_on: bool) -> void:
	$stylus_debug.visible = toggled_on
