extends Node2D

@onready var anim_player = $AnimationPlayer

# 1 in 10 chance (0.1) - make this smaller (e.g., 0.05) to make encounters rarer
var encounter_chance = 1
var is_active = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Play the rustle animation
	anim_player.play("Stepped")
	
	# Check if the thing that entered is the player
	if body is CharacterBody2D and is_active:
		# Play the rustle animation
		anim_player.play("Stepped")
		
		# Deactivate this patch immediately
		is_active = false
		
		roll_for_encounter()
		
		# Wait 3 seconds before this specific patch can trigger again
		await get_tree().create_timer(3.0).timeout
		is_active = true
		
func roll_for_encounter():
	if randf() < encounter_chance:
		# 1. Save state of p[layer (after battle hopefully stays)
		Global.save_player_state(get_tree().current_scene.get_node("Player").global_position, get_tree().current_scene.scene_file_path)
		
		# 2. Start the fade and WAIT for it to turn pitch black
		await Transition.fade_to_black() 
		
		# 3. Change scene ONLY after the fade is done
		get_tree().change_scene_to_file("res://battle_scene.tscn")
