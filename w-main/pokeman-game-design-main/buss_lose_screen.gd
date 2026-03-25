extends Control

func _ready():
	$playerleaves.play("idle")
	$grave.position.y = 800.0
	await get_tree().create_timer(1.0).timeout
	await grave_rise()
	launch_player()

func grave_rise():
	$grave.play("rise")
	
	var tween = create_tween()
	tween.tween_property($grave, "position:y", 123, 0.3).set_ease(Tween.EASE_OUT)
	await tween.finished

func launch_player():
	$playerleaves.flip_v = true
	$playerleaves.play("walk")
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property($playerleaves, "position", Vector2(1400.0, -300.0), 2)
	tween.tween_property($playerleaves, "rotation", deg_to_rad(720.0), 1.5)
