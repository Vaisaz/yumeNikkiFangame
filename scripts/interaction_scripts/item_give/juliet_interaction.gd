extends Area2D

var messages = [
	"",
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
			if index <= 2:
				sound.stream = blips[random_blips.randi_range(0, 2)]
				sound.play()
			elif index > 2 and index < 5:
				sound.stream = soul_blips[random_blips.randi_range(0, 2)]
				sound.play()
			elif index == 5:
				sound.stream = blips[random_blips.randi_range(0, 2)]
				sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true

func _input(event):
	if event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		print(index)
		canvas_layer.visible = true
		if index == 0:
			item_give()
		if index == 0:
			canvas_layer.visible = false
			interaction_times = 1
			GlobalVariables.debounce = false
			return
		message_displayed = false
		index += 1
		show_message()
		
func item_give_structure():
	Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[6]
	Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[6]
	Inventory.items[Inventory.index].disabled = false
	Inventory.ring_has_interacted = true

func item_give():
	Inventory.index = 0
	for item_count in Inventory.items:
		Inventory.items_disabled_checker()
		if !Inventory.all_items_enabled:
			print(item_count)
			if Inventory.index == 0 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 1 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 2 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 3 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 4 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 5 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 6 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 7 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 8 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 9 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 10 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if Inventory.index == 11 and Inventory.items[Inventory.index].disabled and !Inventory.ring_has_interacted:
				item_give_structure()
			if !Inventory.ring_has_interacted:
				Inventory.index += 1
		Inventory.index
