extends Node2D

@onready var player = $Player
@onready var final_boss = $FinalBoss

func _ready():
	Transition.fade_from_black()
	if Global.player_map_position != Vector2.ZERO:
		# Give the player 1.5 seconds of peace
		Global.start_encounter_cooldown(1.5) 
	final_boss.visible = false
	final_boss.process_mode = Node.PROCESS_MODE_DISABLED # Disable collisions/logic
	if Global.defeated_trainers.has("Trainer1"):
		spawn_final_boss()

func spawn_final_boss():
	final_boss.visible = true
	final_boss.process_mode = Node.PROCESS_MODE_INHERIT
		# Snapping logic from before
	var snapped_pos = Global.player_map_position.snapped(Vector2(16, 16))
	player.global_position = snapped_pos
	player.initial_postion = snapped_pos
	Global.player_map_position = Vector2.ZERO
