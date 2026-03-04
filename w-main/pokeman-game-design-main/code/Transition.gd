extends CanvasLayer

@onready var rect = $ColorRect

func fade_to_black():
	rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = create_tween()
	# Animates the shader 'progress' from 0 (invisible) to 1 (full black)
	await tween.tween_property(rect.material, "shader_parameter/progress", 1.0, 0.8).set_trans(Tween.TRANS_SINE).finished

func fade_from_black():
	var tween = create_tween()
	# Animates the shader 'progress' from 1 back to 0
	await tween.tween_property(rect.material, "shader_parameter/progress", 0.0, 0.8).set_trans(Tween.TRANS_SINE).finished
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
