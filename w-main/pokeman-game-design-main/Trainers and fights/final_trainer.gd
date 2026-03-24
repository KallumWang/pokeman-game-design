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
		MusicManager.play_music("res://evil laugh.mp3")
		# 1. Freeze the player
		body.set_physics_process(false)
		
		# 2. Show the alert '!'
		if Alert_Sprite:
			Alert_Sprite.visible = true
			var t = create_tween()
			t.tween_property(Alert_Sprite, "scale", Vector2(1.2, 1.2), 0.1)
			t.tween_property(Alert_Sprite, "scale", Vector2(1.0, 1.0), 0.1)

		# 3. Dramatic 2-second Shake
		await apply_screen_shake() 
		
		# 4. Wake up animation
		if anim_sprite:
			anim_sprite.play("default")
			await anim_sprite.animation_finished

		# 5. Transition to Boss
		Global.save_player_state(body.global_position, get_tree().current_scene.scene_file_path)
		Global.current_trainer_name = name 
		
		await Transition.fade_to_black()
		# Unfreeze just in case, though the scene is changing
		body.set_physics_process(true) 
		get_tree().change_scene_to_file("res://Trainers and fights/BossFight.tscn")

func apply_screen_shake():
	var camera = get_viewport().get_camera_2d()
	if camera:
		var original_pos = camera.offset
		var shake_tween = create_tween()
		
		# 25 loops at 0.08s each = ~2 seconds of total shaking
		for i in range(25):
			shake_tween.tween_property(camera, "offset", Vector2(randf_range(-7, 7), randf_range(-7, 7)), 0.04)
			shake_tween.tween_property(camera, "offset", original_pos, 0.04)
		
		await shake_tween.finished
