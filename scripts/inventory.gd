extends Control

var item_texture = [
	preload("res://assets/inventory/items/banana.png"),
	preload("res://assets/inventory/items/watches.png"),
	preload("res://assets/inventory/items/wnp.png"),
	preload("res://assets/inventory/items/lemonade.png"),
	preload("res://assets/inventory/items/dice.png")
]

var item_texture_hover = [
	preload("res://assets/inventory/items/banana_hover.png"),
	preload("res://assets/inventory/items/watches_hover.png"),
	preload("res://assets/inventory/items/wnp_hover.png"),
	preload("res://assets/inventory/items/lemonade_hover.png"),
	preload("res://assets/inventory/items/dice_hover.png")
]

@onready var items = [
	$InventoryLayer/InventoryChoosed/first,
	$InventoryLayer/InventoryChoosed/second,
	$InventoryLayer/InventoryChoosed/third,
	$InventoryLayer/InventoryChoosed/fourth,
	$InventoryLayer/InventoryChoosed/fifth,
	$InventoryLayer/InventoryChoosed/sixth,
	$InventoryLayer/InventoryChoosed/seventh,
	$InventoryLayer/InventoryChoosed/eighth,
	$InventoryLayer/InventoryChoosed/ninth,
	$InventoryLayer/InventoryChoosed/tenth,
	$InventoryLayer/InventoryChoosed/eleventh,
	$InventoryLayer/InventoryChoosed/twelfth
]

@onready var equipped = $InventoryLayer/SoulChoosed/Equipped
@onready var soul = $InventoryLayer/SoulChoosed/SoulLabel
@onready var lv = $InventoryLayer/SoulChoosed/LVLabel
@onready var hp = $InventoryLayer/SoulChoosed/HPLabel
@onready var at = $InventoryLayer/SoulChoosed/ATLabel
@onready var xp = $InventoryLayer/SoulChoosed/XPLabel
@onready var co = $InventoryLayer/SoulChoosed/COLabel

@onready var soul_button = $InventoryLayer/Buttons/Soul
@onready var inventory_button = $InventoryLayer/Buttons/Inventory
@onready var quit_button = $InventoryLayer/Buttons/Quit

@onready var inventory_layer = $InventoryLayer
@onready var soul_choosed = $InventoryLayer/SoulChoosed
@onready var inventory_choosed = $InventoryLayer/InventoryChoosed

@onready var eye = $InventoryLayer/SoulChoosed/AnimatedSprite2D

var index = 0
var banana_has_interacted: bool = false
var watches_has_interacted: bool = false
var wnp_has_interacted: bool = false
var dice_has_interacted:bool = false
var rng = RandomNumberGenerator.new()

var lemonade_has_interacted: bool = false

var coins = 100
var add_coins

func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	soul_button.texture_focused = soul_button.texture_hover
	inventory_button.texture_focused = inventory_button.texture_hover
	quit_button.texture_focused = quit_button.texture_hover
		
func _on_soul_pressed():
	hp.text = "HP: %d/%d" % [Combat.player_current_health, Combat.player_max_health]
	at.text = "AT: %d" % Combat.player_attack
	co.text = "CO: %d" % coins
	lv.text = "LV: %d" % Combat.lv
	xp.text = "XP: %d/%d" % [Combat.xp, Combat.max_xp]
	soul_choosed.visible = true
	inventory_choosed.visible = false

func _on_inventory_pressed():
	inventory_choosed.visible = true
	soul_choosed.visible = false
	if !$InventoryLayer/InventoryChoosed/first.disabled or !$InventoryLayer/InventoryChoosed/second.disabled or !$InventoryLayer/InventoryChoosed/third.disabled:
		if !$InventoryLayer/InventoryChoosed/first.disabled:
			$InventoryLayer/InventoryChoosed/first.grab_focus()
		if !$InventoryLayer/InventoryChoosed/second.disabled:
			$InventoryLayer/InventoryChoosed/second.grab_focus()
		if !$InventoryLayer/InventoryChoosed/third.disabled:
			$InventoryLayer/InventoryChoosed/third.grab_focus()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _on_quit_pressed():
	get_tree().quit()

var banana_equipped = false
var watches_equipped = false
var wnp_equipped = false
var dice_equipped = false

func item_on_equip(item_index):
	soul_choosed.visible = false
	inventory_choosed.visible = false
	if items[item_index].texture_normal == load("res://assets/inventory/items/lemonade.png"):
		items[item_index].texture_normal = null
		items[item_index].texture_hover = null
		items[item_index].disabled = true
		if Combat.player_current_health <= Combat.player_max_health:
			Combat.player_current_health += 25
		if Combat.player_current_health > Combat.player_max_health:
			Combat.player_current_health = Combat.player_max_health
		index = 0
	else: 
		equipped.texture = items[item_index].texture_normal
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	inventory_button.grab_focus()
	if equipped.texture == load("res://assets/inventory/items/banana.png") and !banana_equipped:
		Combat.player_attack = 10
		Combat.player_max_health = 50
		Combat.player_attack -= 5
		Combat.player_max_health += 25
		banana_equipped = true
		watches_equipped = false
		wnp_equipped = false
		dice_equipped = false
	elif equipped.texture == load("res://assets/inventory/items/watches.png") and !watches_equipped:
		Combat.player_attack = 10
		Combat.player_max_health = 50
		Combat.player_attack = Combat.player_attack + 10
		banana_equipped = false
		watches_equipped = true	
		wnp_equipped = false
		dice_equipped = false
	elif equipped.texture == load("res://assets/inventory/items/dice.png") and !dice_equipped:
		Combat.player_attack = 10
		Combat.player_max_health = 50
		banana_equipped = false
		watches_equipped = false	
		wnp_equipped = false
		dice_equipped = true
	
func item_on_unequip():
	soul_choosed.visible = false
	inventory_choosed.visible = false
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	inventory_button.grab_focus()
	Combat.player_attack = 10
	Combat.player_max_health = 50
	banana_equipped = false
	watches_equipped = false
	wnp_equipped = false
	equipped.texture = null
	
var equip: bool = false

func on_pressed_structure(num):
	if items[num].texture_normal == load("res://assets/inventory/items/lemonade.png"):
		item_on_equip(num)
	elif num == 0 and items[0].texture_normal == load("res://assets/inventory/items/hope.png"):
		get_tree().quit()
	else:
		if !equip:
			item_on_equip(num)
			equip = true
		elif equip:
			if items[num].texture_normal == equipped.texture:
				item_on_unequip()
				equip = false	
			elif !items[num].texture_normal == equipped.texture:
				item_on_equip(num)
				equip = true	

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

func _process(_delta):
	if dice_equipped:
		var random_number = rng.randi_range(-2, 2)
		if random_number < 0:
			Combat.player_attack = 0
		else:
			Combat.player_attack += random_number
		at.text = "AT: %d" % Combat.player_attack
		set_process(false)
		await get_tree().create_timer(0.1).timeout
		set_process(true)
