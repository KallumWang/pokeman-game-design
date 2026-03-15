extends Node2D

@onready var player = $Player
# Renamed from final_boss to final_trainer to match your actual node name
@onready var final_trainer = $FinalTrainer 

func _ready():
	Transition.fade_from_black()
	print("Defeated trainers count: ", Global.defeated_trainers.size())
	print("Defeated list: ", Global.defeated_trainers)
	
	# 1. Handle player positioning after battle
	if Global.player_map_position != Vector2.ZERO:
		Global.start_encounter_cooldown(1.5) 
		var snapped_pos = Global.player_map_position.snapped(Vector2(16, 16))
		player.global_position = snapped_pos
		player.initial_postion = snapped_pos
		Global.player_map_position = Vector2.ZERO
	
	# 2. Check if the Final Trainer was already defeated
	if Global.defeated_trainers.has("FinalTrainer"):
		final_trainer.queue_free()
		return

	# 3. Default state: Hide the boss
	final_trainer.visible = false
	final_trainer.process_mode = Node.PROCESS_MODE_DISABLED 

	# 4. Only spawn if the player has beaten at least 3 trainers
	if Global.defeated_trainers.size() >= 6:
		spawn_final_boss()

func spawn_final_boss():
	# This makes the boss appear on the map, but it stays still 
	# until the player enters its Area2D trigger
	final_trainer.visible = true
	final_trainer.process_mode = Node.PROCESS_MODE_INHERIT
