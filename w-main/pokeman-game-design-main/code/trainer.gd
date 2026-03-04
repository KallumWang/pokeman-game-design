extends Node2D

@onready var alert_sprite = $AlertSprite # Make sure this matches your node name!
@onready var player = get_tree().current_scene.get_node_or_null("Player")

func _ready():
	# If this trainer was already beaten, delete them immediately
	if Global.defeated_trainers.has(name):
		queue_free()
	
	# Ensure the '!' is hidden at the start
	alert_sprite.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# 1. Dramatic Pause & Alert
		alert_sprite.visible = true
		
		# Create a little 'pop' animation for the bubble
		var tween = create_tween()
		tween.tween_property(alert_sprite, "scale", Vector2(1.2, 1.2), 0.1)
		tween.tween_property(alert_sprite, "scale", Vector2(1.0, 1.0), 0.1)
		
		# Wait a split second for the player to react
		await get_tree().create_timer(0.4).timeout
		
		# 2. Start Battle Transition
		Global.save_player_state(body.global_position, get_tree().current_scene.scene_file_path)
		
		# Tell the Global script WHICH trainer we are fighting
		Global.current_trainer_name = name 
		
		await Transition.fade_to_black()
		get_tree().change_scene_to_file("res://Trainers and fights/Boss1.tscn")
