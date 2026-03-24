extends Control

func _ready():
	$playerleaves.position.x = -200.0
	$playerleaves.play("walk")
	await walk_to_grave()
	
	$playerleaves.play("idle")
	await get_tree().create_timer(0.5).timeout
	
	await jump()
	run_away()

func walk_to_grave():
	# walk toward the grave
	var tween = create_tween()
	tween.tween_property($playerleaves, "position:x", 235, 2.0)
	await tween.finished

func jump():
	# little hop in place
	var tween = create_tween()
	tween.tween_property($playerleaves, "position:y", $playerleaves.position.y - 30.0, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property($playerleaves, "position:y", $playerleaves.position.y, 0.3).set_ease(Tween.EASE_IN)
	await tween.finished

func run_away():
	# flip to face left and run back off screen
	$playerleaves.flip_h = true
	$playerleaves.play("walk")
	var tween = create_tween()
	tween.tween_property($playerleaves, "position:x", -200, 1.5)
