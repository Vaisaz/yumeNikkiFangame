extends Area2D

var messages = [
	"",
	"I AM A NUMBER ENTHUSIAST.",
	"I GAVE A BIG PORTION OF MY LIFE TO NUMBERS
	AND THERE IS STILL A LOT TO UNCOVER.",
	"I WILL GIVE YOU AN ITEM, MAYBE ONE DAY YOU
	WILL BECOME A NUMBER ENTHUSIAST YOURSELF.",
	"I COULD ALSO BENEFIT FROM YOU.",
	"TALK TO ME AGAIN AND I WILL GIVE YOU THE
	ITEM.",
	"YOU HAVE ACQUIRED WNPV10.127",
	"WNPV10.127 STANDS FOR:
	WEAK NUMBER PISTOL VERSION 10.127",
	"I HOPE I AM GIVING THIS TO GOOD HANDS."
]

var blips = [
	load("res://assets/audio/number_enthusiast_blips/1.wav"),
	load("res://assets/audio/number_enthusiast_blips/2.wav"),
	load("res://assets/audio/number_enthusiast_blips/3.wav")
]

var soul_blips = [
	load("res://assets/audio/soul_blips/soul1.wav"),
	load("res://assets/audio/soul_blips/soul2.wav"),
	load("res://assets/audio/soul_blips/soul3.wav")
]

var interact: bool = false
var interaction_times = 0

var random = RandomNumberGenerator.new()
var index = 0
var message_displayed: bool = false
var random_blips = RandomNumberGenerator.new()

@onready var label = $"../CanvasLayer/BlankFrameBigger/Label"
@onready var canvas_layer = $"../CanvasLayer"
@onready var sound = $"../Sound"

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		print("eh")
		if index == 0:
			message_displayed = true

func _on_area_exited(_area):
	interact = false

func show_message():
	if index < messages.size():
		label.text = ""
		for character in messages[index]:
			if index <= 5:
				sound.stream = blips[random_blips.randi_range(0, 2)]
				sound.play()
			elif index > 5 and index < 8:
				sound.stream = soul_blips[random_blips.randi_range(0, 2)]
				sound.play()
			elif index == 8:
				sound.stream = blips[random_blips.randi_range(0, 2)]
				sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true

func _input(event):
	if interaction_times == 0 and !Inventory.wnp_has_interacted and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		print(index)
		canvas_layer.visible = true
		if index == 5:
			canvas_layer.visible = false
			interaction_times = 1
			GlobalVariables.debounce = false
			return
		message_displayed = false
		index += 1
		show_message()
	if interaction_times == 1 and !Inventory.wnp_has_interacted and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		Inventory.index = 0
		for item_count in Inventory.items:
			print(item_count)
			if Inventory.index == 0 and Inventory.items[Inventory.index].disabled and !Inventory.wnp_has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[2]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[2]
				Inventory.items[Inventory.index].disabled = false
				GlobalVariables.debounce = false
				interaction_times = interaction_times + 1
				Inventory.wnp_has_interacted = true
			if Inventory.index == 1 and Inventory.items[Inventory.index].disabled and !Inventory.wnp_has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[2]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[2]
				Inventory.items[Inventory.index].disabled = false
				GlobalVariables.debounce = false
				interaction_times = interaction_times + 1
				Inventory.wnp_has_interacted = true
			if Inventory.index == 2 and Inventory.items[Inventory.index].disabled and !Inventory.wnp_has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[2]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[2]
				Inventory.items[Inventory.index].disabled = false
				GlobalVariables.debounce = false
				interaction_times = interaction_times + 1
				Inventory.wnp_has_interacted = true
			if !Inventory.wnp_has_interacted:
				Inventory.index += 1
				
	if interaction_times == 2 and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		print(index)
		canvas_layer.visible = true
		if index == 8:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			return
		message_displayed = false
		index += 1
		show_message()
