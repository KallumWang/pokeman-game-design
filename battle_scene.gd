extends Node2D

# --- DATA ---
var player_hp = 100
var enemy_hp = 450
var lucky_multiplier: float = 2.0
var lucky_move_index: int = -1

# --- NODES ---
@onready var player_spawn = $PlayerSpawn
@onready var enemy_spawn = $EnemySpawn

# --- SPRITES ---
var player_sprite = Sprite2D.new()
var enemy_sprite = Sprite2D.new()

# --- STATE ---
var is_player_turn = true

func _ready():
	randomize() # Essential: Ensures a different lucky move every time you play
	setup_sprites()
	pick_lucky_move()
	
	print("--- BATTLE START ---")
	print("Press '1' for Tackle (20) or '2' for Fireball (35)")

func setup_sprites():
	# 1. Add sprites to the scene
	player_spawn.add_child(player_sprite)
	enemy_spawn.add_child(enemy_sprite)
	
	# 2. Set textures (Replace "res://icon.svg" with your actual art paths)
	player_sprite.texture = load("res://icon.svg")
	enemy_sprite.texture = load("res://icon.svg")
	player_sprite.scale = Vector2(0.5, 0.5) 
	enemy_sprite.scale = Vector2(0.5, 0.5)
	
	# 3. Initial Position: Start them off-screen for the slide-in effect
	player_sprite.global_position = player_spawn.global_position + Vector2(-600, 0)
	enemy_sprite.global_position = enemy_spawn.global_position + Vector2(600, 0)
	
	# 4. Slide Intro Tween
	var intro_tween = create_tween().set_parallel(true)
	intro_tween.tween_property(player_sprite, "position", Vector2.ZERO, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	intro_tween.tween_property(enemy_sprite, "position", Vector2.ZERO, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func pick_lucky_move():
	# Randomly pick 0, 1, 2
	lucky_move_index = randi() % 3
	var move_names = ["Tackle", "Fireball","Kidnap"]
	print("DEBUG: The lucky move for this fight is: ", move_names[lucky_move_index])

func _input(_event):
	if not is_player_turn: return
	
	if Input.is_key_pressed(KEY_1):
		execute_player_move(0, "Tackle", 25)
	elif Input.is_key_pressed(KEY_2):
		execute_player_move(1, "Fireball", 35)
	elif Input.is_key_pressed(KEY_3):
		execute_player_move(2, "Kidnap", 30)

func execute_player_move(move_id: int, move_name: String, base_damage: int):
	is_player_turn = false
	var final_damage = base_damage
	
	if move_id == lucky_move_index:
		final_damage = int(base_damage * lucky_multiplier)
		print("!!! LUCKY HIT !!!")
		# Use the spawn_pos and yellow color
		spawn_damage_number(final_damage, enemy_spawn.global_position, Color.YELLOW)
		flash_sprite(enemy_sprite, Color.YELLOW)
	else:
		spawn_damage_number(final_damage, enemy_spawn.global_position, Color.WHITE)
		flash_sprite(enemy_sprite, Color.RED)
	
	print("Player used ", move_name, "! Dealt ", final_damage, " damage.")
	enemy_hp -= final_damage
	enemy_hp = max(0, enemy_hp)
	
	check_battle_status("enemy")

func enemy_turn():
	print("\nEnemy's Turn...")
	await get_tree().create_timer(1.0).timeout
	
	var damage = 15
	player_hp -= damage
	player_hp = max(0, player_hp)
	
	# Spawn damage number over the player
	spawn_damage_number(damage, player_spawn.global_position, Color.WHITE)
	
	print("Enemy used Slash! Dealt ", damage, " damage.")
	flash_sprite(player_sprite, Color.RED)
	check_battle_status("player")

func check_battle_status(last_target: String):
	print("HP -> Player: ", player_hp, " | Enemy: ", enemy_hp)
	
	if enemy_hp <= 0:
		print("YOU WIN!")
		victory_animation(enemy_sprite)
	elif player_hp <= 0:
		print("GAME OVER...")
		victory_animation(player_sprite)
	else:
		# If battle continues, switch turns
		if last_target == "enemy":
			enemy_turn()
		else:
			is_player_turn = true

# --- VISUAL HELPERS ---

func flash_sprite(sprite: Sprite2D, color: Color):
	var tween = create_tween()
	# Shake and Color Flash
	tween.tween_property(sprite, "modulate", color, 0.1)
	tween.parallel().tween_property(sprite, "offset", Vector2(10, 0), 0.05)
	tween.tween_property(sprite, "offset", Vector2(-10, 0), 0.05)
	tween.tween_property(sprite, "offset", Vector2(0, 0), 0.05)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)

func victory_animation(defeated_sprite: Sprite2D):
	# Make the loser fade away and sink
	var tween = create_tween()
	tween.parallel().tween_property(defeated_sprite, "modulate:a", 0, 0.5)
	tween.parallel().tween_property(defeated_sprite, "position:y", 100, 0.5)
	set_process_input(false) # Disable further keys
	
func spawn_damage_number(amount: int, target_position: Vector2, color: Color):
	var label = Label.new()
	label.text = str(amount)
	
	# FIX: Use theme override instead of direct property access
	label.add_theme_font_size_override("font_size", 32)
	
	label.modulate = color
	
	# Position and Animation logic remains the same...
	label.global_position = target_position + Vector2(-20, -50)
	add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "position:y", label.position.y - 100, 0.7)
	tween.parallel().tween_property(label, "modulate:a", 0, 0.7)
	tween.tween_callback(label.queue_free)


func _on_move_1_pressed() -> void:
	pass # Replace with function body.


func _on_move_2_pressed() -> void:
	pass # Replace with function body.


func _on_move_3_pressed() -> void:
	pass # Replace with function body.
