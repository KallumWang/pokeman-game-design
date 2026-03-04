extends Node2D

@onready var player = $Player

func _ready():
	Transition.fade_from_black()
	if Global.player_map_position != Vector2.ZERO:
		# Give the player 1.5 seconds of peace
		Global.start_encounter_cooldown(1.5) 
		
		# Snapping logic from before
		var snapped_pos = Global.player_map_position.snapped(Vector2(16, 16))
		player.global_position = snapped_pos
		player.initial_postion = snapped_pos
		Global.player_map_position = Vector2.ZERO
