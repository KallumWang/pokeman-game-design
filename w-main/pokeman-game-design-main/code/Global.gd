extends Node

var player_map_position: Vector2 = Vector2.ZERO
var current_map_path: String = ""

# New: Tracks disabled grass patches by their name or ID
var disabled_grass_patches = {} 

func save_player_state(pos: Vector2, map_path: String):
	player_map_position = pos
	current_map_path = map_path

func disable_patch(patch_name: String, duration: float):
	disabled_grass_patches[patch_name] = true
	# Use a scene tree timer from the Global node itself
	await get_tree().create_timer(duration).timeout
	# Check if the key still exists before erasing to prevent errors
	if disabled_grass_patches.has(patch_name):
		disabled_grass_patches.erase(patch_name)
