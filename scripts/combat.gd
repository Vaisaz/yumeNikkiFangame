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

@onready var damaged_sound = $DamagedSound
@onready var leveled_sound = $LeveledSound

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
	items_button.disabled = false

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
		if !Inventory.equipped.texture == null:
			Inventory.item_on_unequip()
		leveled_sound.play()
		player_max_health = 55
		player_attack = 15
		lv = 2
		if xp > 25:
			xp -= 25
		else:
			xp = 0
		max_xp = 50
		player_current_health = player_max_health
	if xp >= 50 and lv == 2:
		if !Inventory.equipped.texture == null:
			Inventory.item_on_unequip()
		leveled_sound.play()
		player_max_health = 60
		player_attack = 20
		lv = 3
		if xp > 50:
			xp -= 50
		else:
			xp = 0
		max_xp = 200
		player_current_health = player_max_health
	if xp >= 200 and lv == 3:
		if !Inventory.equipped.texture == null:
			Inventory.item_on_unequip()
		leveled_sound.play()
		player_max_health = 80
		player_attack = 40
		lv = 4
		if xp > 200:
			xp -= 200
		else:
			xp = 0
		max_xp = 450
		player_current_health = player_max_health
	if xp >= 450 and lv == 4:
		if !Inventory.equipped.texture == null:
			Inventory.item_on_unequip()
		leveled_sound.play()
		player_max_health = 100
		player_attack = 60
		lv = 5
		if xp > 450:
			xp -= 450
		else:
			xp = 0
		max_xp = 0
		player_current_health = player_max_health
		

func combat(player_attack, damaged):
	var turn = rng.randi_range(1, 2)
	fight_button.disabled = true
	run_button.disabled = true
	items_button.disabled = true
	if turn == 1:
		enemy_current_health = enemy_current_health - player_attack
		enemy_health(enemy_current_health, enemy_max_health)
		if damaged:
			damaged_sound.play()
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
				items_button.disabled = false
				DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
		else:
			player_current_health = player_current_health - enemy_attack
			player_health()
			damaged_sound.play()
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
			items_button.disabled = false
			if player_current_health <= 0:
				if GlobalVariables.outfit == 1:
					GlobalVariables.player_position = Vector2(-47,-43)
					combat_sound.stop()
					GlobalVariables.debounce = true
					GlobalVariables.in_combat = true
					fight_button.disabled = false
					run_button.disabled = false
					items_button.disabled = false
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
		damaged_sound.play()
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
					GlobalVariables.player_position = Vector2(-47,-43)
					combat_sound.stop()
					GlobalVariables.debounce = true
					GlobalVariables.in_combat = true
					fight_button.disabled = false
					run_button.disabled = false
					items_button.disabled = false
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
				damaged_sound.play()
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
			items_button.disabled = false
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
					items_button.disabled = false
					DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)

func _on_fight_button_pressed():
	combat(player_attack, true)
	if enemy_texture.texture == load("res://assets/inventory/dream_eye/1.png"):
		items_button.visible = true
		items_button.disabled = false
		
func _on_run_button_pressed():
	if enemy_texture.texture == load("res://assets/inventory/dream_eye/1.png"):
		run_button.disabled = true
		run_button.visible = false
	elif enemy_texture.texture == load("res://assets/combat/old_man_sprite_sheet.png") or player_current_health <= player_max_health * 0.5:	
		player_current_health = player_current_health - enemy_attack
		player_health()
		damaged_sound.play()
		you.visible = false
		await get_tree().create_timer(0.1).timeout
		you.visible = true
		await get_tree().create_timer(0.1).timeout
		you.visible = false
		await get_tree().create_timer(0.1).timeout
		you.visible = true
		await get_tree().create_timer(0.1).timeout
		if player_current_health <= 0:
			GlobalVariables.player_position = Vector2(-47,-43)
			combat_sound.stop()
			GlobalVariables.debounce = true
			GlobalVariables.in_combat = true
			fight_button.disabled = false
			run_button.disabled = false
			items_button.disabled = false
			combat_layer.visible = false
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
			get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
			Transition.ending_animation_full()
			GlobalVariables.debounce = false
			GlobalVariables.in_combat = false
			player_current_health = 1
	else:
		combat_sound.stop()
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
	if items[0].texture_normal == load("res://assets/inventory/items/hope.png"):
		fight_button.disabled = true
		items_button.disabled = true
		fight_button.visible = false
		items_button.visible = false
		enemy_texture.visible = false
		you.visible = false
		enemy_bar.visible = false
		player_bar.visible = false
		combat_sound.stop()
		combat_sound.stream = load("res://assets/audio/picked_up.wav")
		await get_tree().create_timer(0.5).timeout
		combat_sound.play()
		await Combat.combat_sound.finished
		enemy_texture.visible = true
		enemy_texture.texture = load("res://assets/sprites/main/jon_sprite.png")
		you.visible = true
		await get_tree().create_timer(0.1).timeout
		you.text = "YOU"
		await get_tree().create_timer(0.1).timeout
		you.text = "ME"
		await get_tree().create_timer(0.1).timeout
		you.text = "YOU"
		await get_tree().create_timer(0.1).timeout
		you.text = "ME"
		await get_tree().create_timer(0.1).timeout
		get_tree().quit()
	else:
		player_health()
		fight_button.disabled = true
		run_button.disabled = true
		items_button.disabled = true
		await get_tree().create_timer(0.4).timeout
		combat(0, false)
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
	GlobalVariables.player_position = Vector2(41,72)
	combat_sound.stop()
	Inventory.coins += Inventory.add_coins
	for n in 12:
		if !items[n].disabled:
			items[n].visible = true
			items[n].disabled = false
	items[0].texture_normal = load("res://assets/inventory/items/hope.png")
	items[0].texture_hover = load("res://assets/inventory/items/hope_hover.png")
	items[0].visible = true
	items[0].disabled = false
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
	Inventory.xp.visible = false
	Inventory.lv.visible = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
