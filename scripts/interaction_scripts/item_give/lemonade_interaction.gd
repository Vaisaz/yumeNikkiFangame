extends Area2D

var messages = [
	"",
	"YO",
	"WANNA BUY SOME LEMONADE?",
	"IT'LL COST YA 5 COINS",
	"JUST TALK TO ME AGAIN AND I'LL SELL YOU ONE",
	"YOU HAVE ACQUIRED:
	LEMONADE
	
	ONE USE ITEM",
	"GIVES AND TAKES:
	+25 HP
	0 AT"
]

var blips = [
	load("res://assets/audio/lemonade_blips/blip1.wav"),
	load("res://assets/audio/lemonade_blips/blip2.wav"),
	load("res://assets/audio/lemonade_blips/blip3.wav")
]

var soul_blips = [
	load("res://assets/audio/soul_blips/soul1.wav"),
	load("res://assets/audio/soul_blips/soul2.wav"),
	load("res://assets/audio/soul_blips/soul3.wav")
]

var index = 0
var interact: bool = false
var message_displayed: bool = false
var interaction_times = 0
var has_interacted: bool = false
var random = RandomNumberGenerator.new()

@onready var label = $"../CanvasLayer/BlankFrameBigger/Label"
@onready var canvas_layer = $"../CanvasLayer"
@onready var sound = $"../Sound"
@onready var register_sound = $"../RegisterSound"

func _on_area_entered(area):
	print("entered")
	if area.is_in_group("Player"):
		interact = true
	if index == 0:
		message_displayed = true
		
func _on_area_exited(_area):
	print("exited")
	interact = false
	
func show_message():
	if index < messages.size():
		label.text = ""
		for character in messages[index]:
			if index <= 4:
				sound.stream = blips[random.randi_range(0, 2)]
				sound.play()
			elif index > 4:
				sound.stream =soul_blips[random.randi_range(0, 2)]
				sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true
		
func _input(event):
	if interact:
		Inventory.items_disabled_checker()
	if interaction_times == 0 and interact and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and Inventory.coins >= 5 and !Inventory.all_items_enabled:
		if Inventory.lemonade_has_interacted:
			interaction_times = 2
			has_interacted = false
			return
		print("works")
		GlobalVariables.debounce = true
		GlobalVariables.in_combat = true
		canvas_layer.visible = true
		print(index)
		if index == 4:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			GlobalVariables.in_combat = false
			interaction_times = 1
			message_displayed = true
		else:
			message_displayed = false
			index += 1
			show_message()
	elif interaction_times == 1 and interact and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and Inventory.coins >= 5:
		if index == 4:
			register_sound.play()
		GlobalVariables.debounce = true
		GlobalVariables.in_combat = true
		canvas_layer.visible = true
		print(index)
		if index == 6:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			GlobalVariables.in_combat = false
			interaction_times = 2
			return
		message_displayed = false
		index += 1
		show_message()
	elif interaction_times == 2 and message_displayed and interact and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and Inventory.coins >= 5:
		if !Inventory.index >= 12:
			register_sound.play()
		for item_count in Inventory.items:
			print(item_count)
			if Inventory.index == 0:
				item_give_structure()
			if Inventory.index == 1:
				item_give_structure()
			if Inventory.index == 2:
				item_give_structure()
			if Inventory.index == 3:
				item_give_structure()
			if Inventory.index == 4:
				item_give_structure()
			if Inventory.index == 5:
				item_give_structure()
			if Inventory.index == 6:
				item_give_structure()
			if Inventory.index == 7:
				item_give_structure()
			if Inventory.index == 8:
				item_give_structure()
			if Inventory.index == 9:
				item_give_structure()
			if Inventory.index == 10:
				item_give_structure()	
			if Inventory.index == 11:
				item_give_structure()
			if !has_interacted:
				Inventory.index += 1
				
		if interaction_times == 2 and message_displayed and interact and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and Inventory.coins >= 0:\
			interaction_times = 0

func item_give_structure():
	if Inventory.items[Inventory.index].disabled and !has_interacted:
		Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[3]
		Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[3]
		Combat.items[Inventory.index].texture_normal = Inventory.item_texture[3]
		Combat.items[Inventory.index].texture_hover = Inventory.item_texture_hover[3]
		Combat.items[Inventory.index].disabled = false
		Inventory.items[Inventory.index].disabled = false
		Inventory.lemonade_has_interacted = true
		has_interacted = true
		Inventory.coins -= 5
		interaction_times = 2
