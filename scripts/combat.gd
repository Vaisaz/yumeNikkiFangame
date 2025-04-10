extends Control

@onready var fight_button = $Combat/FightButton
@onready var run_button = $Combat/RunButton
@onready var items_button = $Combat/ItemsButton
@onready var combat_layer = $Combat

@onready var enemy_texture = $Combat/Enemy
@onready var enemy_bar = $Combat/EnemyBar
@onready var enemy_label = $Combat/EnemyBar/Label

@onready var player_bar = $Combat/PlayerBar
@onready var player_label = $Combat/PlayerBar/Label
@onready var you = $Combat/You

@onready var combat_sound = $Combat/CombatSound

@onready var items = [
	$Combat/ItemsLayer/first,
	$Combat/ItemsLayer/second,
	$Combat/ItemsLayer/third,
	$Combat/ItemsLayer/fourth,
	$Combat/ItemsLayer/fifth,
	$Combat/ItemsLayer/sixth,
	$Combat/ItemsLayer/seventh,
	$Combat/ItemsLayer/eighth,
	$Combat/ItemsLayer/ninth,
	$Combat/ItemsLayer/tenth,
	$Combat/ItemsLayer/eleventh,
	$Combat/ItemsLayer/twelfth
]

var rng = RandomNumberGenerator.new()

var player_max_health = 50
var player_current_health = 50
var player_attack = 10
var xp = 0
var max_xp = 25
var add_xp = 0
var lv = 1

var enemy_max_health 
var enemy_current_health
var enemy_attack

func _ready():
	fight_button.disabled = false
	run_button.disabled = false

func player_health():
	player_bar.max_value = player_max_health
	player_bar.value = player_current_health
	player_label.text = "HP: %d/%d" % [player_current_health, player_max_health]

@warning_ignore("shadowed_variable")
func enemy_health(enemy_current_health, enemy_max_health):
	enemy_bar.max_value = enemy_max_health
	enemy_bar.value = enemy_current_health
	enemy_label.text = "HP: %d/%d" % [enemy_current_health, enemy_max_health]

func leveling_structure(xp_value, lv_value, max_xp_update, max_health, attack):
	xp += add_xp
	if xp >= xp_value and lv == lv_value:
		player_max_health = max_health
		player_attack = attack
		lv = lv_value
		if xp > xp_value:
			xp -= xp_value
		else:
			xp = 0
		max_xp = max_xp_update
		player_current_health = player_max_health

func leveling():
	xp += add_xp
	if xp >= 25 and lv == 1:
		player_max_health = 55
		player_attack = 15
		lv = 2
		if xp > 25:
			xp -= 25
		else:
			xp = 0
		max_xp = 50
		player_current_health = player_max_health
	elif xp >= 50 and lv == 2:
		player_max_health = 60
		player_attack = 20
		lv = 3
		if xp > 25:
			xp -= 25
		else:
			xp = 0
		max_xp = 200
		player_current_health = player_max_health
	elif xp >= 200 and lv == 3:
		player_max_health = 80
		player_attack = 40
		lv = 4
		if xp > 25:
			xp -= 25
		else:
			xp = 0
		max_xp = 450
		player_current_health = player_max_health
	elif xp >= 450 and lv == 4:
		player_max_health = 100
		player_attack = 60
		lv = 5
		if xp > 25:
			xp -= 25
		else:
			xp = 0
		max_xp = 0
		player_current_health = player_max_health
		

func combat(player_attack, damaged):
	var turn = rng.randi_range(1, 2)
	fight_button.disabled = true
	run_button.disabled = true
	if turn == 1:
		enemy_current_health = enemy_current_health - player_attack
		enemy_health(enemy_current_health, enemy_max_health)
		if damaged:
			enemy_texture.visible = false
			await get_tree().create_timer(0.1).timeout
			enemy_texture.visible = true
			await get_tree().create_timer(0.1).timeout
			enemy_texture.visible = false
			await get_tree().create_timer(0.1).timeout
			enemy_texture.visible = true
			await get_tree().create_timer(0.1).timeout
		if enemy_current_health <= 0:
			if enemy_texture.texture == load("res://assets/combat/old_man_sprite_sheet.png"):
				old_man_defeat()
			else:
				leveling()
				combat_sound.stop()
				Inventory.coins += Inventory.add_coins
				GlobalVariables.debounce = false
				GlobalVariables.in_combat = false
				combat_layer.visible = false
				fight_button.disabled = false
				run_button.disabled = false
				DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
		else:
			player_current_health = player_current_health - enemy_attack
			player_health()
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
			if player_current_health <= 0:
				if GlobalVariables.outfit == 1:
					combat_sound.stop()
					GlobalVariables.debounce = true
					GlobalVariables.in_combat = true
					fight_button.disabled = false
					run_button.disabled = false
					combat_layer.visible = false
					DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
					get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
					Transition.ending_animation_full()
					GlobalVariables.debounce = false
					GlobalVariables.in_combat = false
					player_current_health = 1
				else:
					get_tree().quit()
	if turn == 2:
		player_current_health = player_current_health - enemy_attack
		player_health()
		you.visible = false
		await get_tree().create_timer(0.1).timeout
		you.visible = true
		await get_tree().create_timer(0.1).timeout
		you.visible = false
		await get_tree().create_timer(0.1).timeout
		you.visible = true
		await get_tree().create_timer(0.1).timeout
		if player_current_health <= 0:
			if GlobalVariables.outfit == 1:
					combat_sound.stop()
					GlobalVariables.debounce = true
					GlobalVariables.in_combat = true
					fight_button.disabled = false
					run_button.disabled = false
					combat_layer.visible = false
					DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
					get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
					Transition.ending_animation_full()
					GlobalVariables.debounce = false
					GlobalVariables.in_combat = false
					player_current_health = 1
			else:
				get_tree().quit()
		else:
			enemy_current_health = enemy_current_health - player_attack
			enemy_health(enemy_current_health, enemy_max_health)
			if damaged:
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
			if enemy_current_health <= 0:
				if enemy_texture.texture == load("res://assets/combat/old_man_sprite_sheet.png"):
					old_man_defeat()
				else:
					leveling()
					combat_sound.stop()
					Inventory.coins += Inventory.add_coins
					GlobalVariables.debounce = false
					GlobalVariables.in_combat = false
					combat_layer.visible = false
					fight_button.disabled = false
					run_button.disabled = false
					DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)

func _on_fight_button_pressed():
	combat(player_attack, true)
		
func _on_run_button_pressed():
	combat_layer.visible = false
	GlobalVariables.debounce = false
	GlobalVariables.in_combat = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)

func _on_items_button_pressed():
	$Combat/ItemsLayer.visible = true
	if !$Combat/ItemsLayer/first.texture_normal == null:
		$Combat/ItemsLayer/first.disabled = false
		$Combat/ItemsLayer/first.visible = true
		
	if !$Combat/ItemsLayer/second.texture_normal == null:
		$Combat/ItemsLayer/second.disabled = false
		$Combat/ItemsLayer/second.visible = true
		
	if !$Combat/ItemsLayer/third.texture_normal == null:
		$Combat/ItemsLayer/third.disabled = false
		$Combat/ItemsLayer/third.visible = true

func on_pressed_structure(num):
	$Combat/ItemsLayer.visible = false
	Inventory.item_on_equip(num)
	combat(0, false)
	items[num].disabled = true
	items[num].visible = false
	items[num].texture_normal = null
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _on_first_pressed():
	on_pressed_structure(0)
	
func _on_second_pressed():
	on_pressed_structure(1)
	
func _on_third_pressed():
	on_pressed_structure(2)
	
func _on_fourth_pressed():
	on_pressed_structure(3)
	
func _on_fifth_pressed():
	on_pressed_structure(4)
	
func _on_sixth_pressed():
	on_pressed_structure(5)
	
func _on_seventh_pressed():
	on_pressed_structure(6)
	
func _on_eighth_pressed():
	on_pressed_structure(7)
	
func _on_ninth_pressed():
	on_pressed_structure(8)
	
func _on_tenth_pressed():
	on_pressed_structure(9)
	
func _on_eleventh_pressed():
	on_pressed_structure(10)
	
func _on_twelfth_pressed():
	on_pressed_structure(11)
	
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		$Combat/ItemsLayer.visible = false

func old_man_defeat():
	GlobalVariables.outfit = 2
	get_tree().change_scene_to_file("res://scenes/locations/dream_room.tscn")
	combat_sound.stop()
	Inventory.coins += Inventory.add_coins
	items[0].texture_normal = load("res://assets/inventory/items/hope.png")
	items[0].texture_hover = load("res://assets/inventory/items/hope_hover.png")
	items[0].visible = true
	items[0].disabled = false
	items[1].visible = false
	items[1].disabled = true
	items[2].visible = false
	items[2].disabled = true
	run_button.disabled = true
	run_button.visible = false
	GlobalVariables.debounce = false
	GlobalVariables.in_combat = false
	combat_layer.visible = false
	fight_button.disabled = false
	run_button.disabled = false
	Inventory.eye.visible = false
	Inventory.soul.visible = false
	Inventory.hp.visible = false
	Inventory.at.visible = false
	Inventory.co.visible = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
