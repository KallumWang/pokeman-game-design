extends Node2D

@onready var anim_sprite = $AnimatedSprite2D
@onready var Alert_Sprite = $AlertSprite

func _ready():
	if Global.defeated_trainers.has(name):
		queue_free()
	
	if Alert_Sprite:
		Alert_Sprite.visible = false
	if anim_sprite:
		anim_sprite.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# 1. Screen Shake & Animation
		if anim_sprite:
			apply_screen_shake() # Start the shake
			anim_sprite.play("default")
		
		# 2. Show the alert '!'
		if Alert_Sprite:
			Alert_Sprite.visible = true
			var tween = create_tween()
			tween.tween_property(Alert_Sprite, "scale", Vector2(1.2, 1.2), 0.1)
			tween.tween_property(Alert_Sprite, "scale", Vector2(1.0, 1.0), 0.1)

		# 3. Wait for animation to finish
		if anim_sprite:
			await anim_sprite.animation_finished

		# 4. Standard Battle Transition
		Global.save_player_state(body.global_position, get_tree().current_scene.scene_file_path)
		Global.current_trainer_name = name 
		
		await Transition.fade_to_black()
		get_tree().change_scene_to_file("res://Trainers and fights/BossFight.tscn")

func apply_screen_shake():
	var camera = get_viewport().get_camera_2d()
	if camera:
		var original_pos = camera.offset
		var shake_tween = create_tween()
		# Rapidly move the camera offset back and forth
		for i in range(5):
			shake_tween.tween_property(camera, "offset", Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
		shake_tween.tween_property(camera, "offset", original_pos, 0.05)
