extends Node2D

@onready var anim_sprite = $AnimatedSprite2D
@onready var Alert_Sprite = $AlertSprite

func _ready():
	# If this trainer was already beaten, delete them immediately
	if Global.defeated_trainers.has(name):
		queue_free()
	
	# Ensure nodes exist before setting properties to prevent crashes
	if Alert_Sprite:
		Alert_Sprite.visible = false
	if anim_sprite:
		anim_sprite.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# 1. Start the 'default' or 'wake' animation
		if anim_sprite:
			anim_sprite.play("default")
		
		# 2. Show the alert '!'
		if Alert_Sprite:
			Alert_Sprite.visible = true
			var tween = create_tween()
			tween.tween_property(Alert_Sprite, "scale", Vector2(1.2, 1.2), 0.1)
			tween.tween_property(Alert_Sprite, "scale", Vector2(1.0, 1.0), 0.1)

		# 3. Wait for the animation to finish before starting the battle
		if anim_sprite:
			await anim_sprite.animation_finished

		# 4. Standard Battle Transition
		Global.save_player_state(body.global_position, get_tree().current_scene.scene_file_path)
		Global.current_trainer_name = name 
		
		await Transition.fade_to_black()
		get_tree().change_scene_to_file("res://Trainers and fights/Boss1.tscn")
