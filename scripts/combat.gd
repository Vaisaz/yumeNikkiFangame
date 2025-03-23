extends Control

@onready var fight_button = $Combat/FightButton
@onready var run_button = $Combat/RunButton
@onready var combat_layer = $Combat

@onready var enemy_texture = $Combat/Enemy
@onready var enemy_bar = $Combat/EnemyBar
@onready var enemy_label = $Combat/EnemyBar/Label

@onready var player_bar = $Combat/PlayerBar
@onready var player_label = $Combat/PlayerBar/Label
@onready var you = $Combat/You

var rng = RandomNumberGenerator.new()

var player_max_health = 50
var player_current_health = 50
var player_attack = 10

var enemy_max_health 
var enemy_current_health
var enemy_attack

func _ready():
	fight_button.disabled = false
	run_button.disabled = false

@warning_ignore("shadowed_variable")
func player_health(player_current_health, player_max_health):
	player_bar.max_value = player_max_health
	player_bar.value = player_current_health
	player_label.text = "HP: %d/%d" % [player_current_health, player_max_health]

@warning_ignore("shadowed_variable")
func enemy_health(enemy_current_health, enemy_max_health):
	enemy_bar.max_value = enemy_max_health
	enemy_bar.value = enemy_current_health
	enemy_label.text = "HP: %d/%d" % [enemy_current_health, enemy_max_health]

func _on_fight_button_pressed():
	var turn = rng.randi_range(1, 2)
	print(turn)
	fight_button.disabled = true
	run_button.disabled = true
	if turn == 1:
		enemy_current_health = enemy_current_health - player_attack
		enemy_health(enemy_current_health, enemy_max_health)
		enemy_texture.visible = false
		await get_tree().create_timer(0.1).timeout
		enemy_texture.visible = true
		await get_tree().create_timer(0.1).timeout
		enemy_texture.visible = false
		await get_tree().create_timer(0.1).timeout
		enemy_texture.visible = true
		await get_tree().create_timer(0.1).timeout
		if enemy_current_health == 0:
			combat_layer.visible = false
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
		else:
			player_current_health = player_current_health - enemy_attack
			player_health(player_current_health, player_max_health)
			you.visible = false
			await get_tree().create_timer(0.1).timeout
			you.visible = true
			await get_tree().create_timer(0.1).timeout
			you.visible = false
			await get_tree().create_timer(0.1).timeout
			you.visible = true
			await get_tree().create_timer(0.1).timeout
			fight_button.disabled = false
			run_button.disabled = false
			if player_current_health == 0:
				get_tree().quit()
	if turn == 2:
		player_current_health = player_current_health - enemy_attack
		player_health(player_current_health, player_max_health)
		you.visible = false
		await get_tree().create_timer(0.1).timeout
		you.visible = true
		await get_tree().create_timer(0.1).timeout
		you.visible = false
		await get_tree().create_timer(0.1).timeout
		you.visible = true
		await get_tree().create_timer(0.1).timeout
		if player_current_health == 0:
			get_tree().quit()
		else:
			enemy_current_health = enemy_current_health - player_attack
			enemy_health(enemy_current_health, enemy_max_health)
			enemy_texture.visible = false
			await get_tree().create_timer(0.1).timeout
			enemy_texture.visible = true
			await get_tree().create_timer(0.1).timeout
			enemy_texture.visible = false
			await get_tree().create_timer(0.1).timeout
			enemy_texture.visible = true
			await get_tree().create_timer(0.1).timeout
			fight_button.disabled = false
			run_button.disabled = false
			if enemy_current_health == 0:
				combat_layer.visible = false
				DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
		
func _on_run_button_pressed():
	combat_layer.visible = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
