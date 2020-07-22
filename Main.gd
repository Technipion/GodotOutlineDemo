extends Spatial

const LW_CONV_FACTOR := 10000 # line width conversion factor
const LI_CONV_FACTOR := 10000 # line intensity conversion factor



func _ready():
	$Control/HSlider.value = 100
	$Control/ColorPicker.color = Color(0, 0.8, 0.8, 1)



func _on_HSlider_value_changed(value):
	$Sprite3D.material_override.next_pass.set_shader_param('line_size', value / LW_CONV_FACTOR)


func _on_ColorPicker_color_changed(color):
	$Sprite3D.material_override.next_pass.set_shader_param('line_color', color)


func _on_ButtonHelp_pressed():
	$Control/Panel.visible = not $Control/Panel.visible


func _on_HSlider2_value_changed(value):
	$Sprite3D.material_override.next_pass.set_shader_param('line_intensity', value / LI_CONV_FACTOR)


func _on_HSlider3_value_changed(value):
	$Sprite3D.material_override.next_pass.set_shader_param('line_lod', value)
