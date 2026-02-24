extends Node2D

@onready var player = $Player

func _ready():
	# 1. ALWAYS fade back in when entering the map
	Transition.fade_from_black()
	
	# 2. Check if we are returning from a battle
	if Global.player_map_position != Vector2.ZERO:
		player.global_position = Global.player_map_position
		# IMPORTANT: Clear this immediately so we don't teleport on next launch
		Global.player_map_position = Vector2.ZERO
