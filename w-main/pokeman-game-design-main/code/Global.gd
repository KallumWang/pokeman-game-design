extends Node
var current_trainer_name: String = "" # Add this at the top of Global.gd
var player_map_position: Vector2 = Vector2.ZERO
var current_map_path: String = ""
var disabled_grass_patches = {} 

# NEW: Track names of defeated trainers
var defeated_trainers = [] 

func save_player_state(pos: Vector2, map_path: String):
	player_map_position = pos
	current_map_path = map_path

func disable_patch(patch_name: String, duration: float):
	disabled_grass_patches[patch_name] = true
	await get_tree().create_timer(duration).timeout
	if disabled_grass_patches.has(patch_name):
		disabled_grass_patches.erase(patch_name)
		
