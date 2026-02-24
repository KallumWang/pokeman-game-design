extends Node2D

@onready var anim_player = $AnimationPlayer

# 1 in 10 chance (0.1) - make this smaller (e.g., 0.05) to make encounters rarer
var encounter_chance = 0.2
var is_active = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if this specific patch is in the Global "disabled" list
	if body is CharacterBody2D and not Global.disabled_grass_patches.has(name):
		anim_player.play("Stepped")
		
		# Tell Global to disable THIS patch name for 5 seconds
		Global.disable_patch(name, 5.0)
		
		roll_for_encounter()

func roll_for_encounter():
	if randf() < encounter_chance:
		# Use the 'safe' way to get the player node
		var player = get_tree().current_scene.get_node_or_null("Player")
		if player:
			Global.save_player_state(player.global_position, get_tree().current_scene.scene_file_path)
		
		await Transition.fade_to_black()
		get_tree().change_scene_to_file("res://battle_scene.tscn")
