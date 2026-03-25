extends Control

func _ready():
	walk_in()

func walk_in():
	$"player arrives".play("walk")
	
	$"player arrives".position.x = 0
	
	var tween = create_tween()
	tween.tween_property($"player arrives", "position", Vector2(156.0, $"player arrives".position.y), 1.5)
	
	await tween.finished
	$"player arrives".play("idle")
