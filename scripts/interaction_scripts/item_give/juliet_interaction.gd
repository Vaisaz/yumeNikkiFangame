extends Area2D

var messages = [
	"",
	"HELLO",
	"I DO NOT GET MUCH VISITORS AROUND HERE",
	"THAT'S WHY I LIKE TO COME HERE OFTEN",
	".  .  .",
	"I FEEL LIKE I KNOW YOU",
	"I'M PRETTY SURE THIS IS THE FIRST TIME
	WE EVER MET",
	".  .  .",
	"I'LL GIVE YOU AN ITEM",
	"I DON'T WANT YOU TO GET HURT",
	"YOU HAVE ACQUIRED:
	RING",
	"ENEMIES DEAL 20% LESS DAMAGE",
	"YOUR HEART BLISSFULLY THROBS IN A
	MELODY",
	"THE STARS SHINING THROUGH YOUR RETINA
	MAKES YOU RELAX COMFORTABLY",
	"MILLIONS OF HOMES WHERE YOUR SCATTERED
	SOULS RESIDE",
	"WITH THE FEMALE SOUL YOU FEEL LIKE YOU
	SHOULD UNITE",
	"AND ALL THE SCATTERED SOULS HAVE THE
	SAME DESTINY",
	"TOWARDS THIS ONE SINGLE ENTITY",
	"YOU HAVE RECOVERED YOUR HEALTH",
]

var blips = load("res://assets/audio/juliet_blips/juliet_blip.wav")

var soul_blips = [
	load("res://assets/audio/soul_blips/soul1.wav"),
	load("res://assets/audio/soul_blips/soul2.wav"),
	load("res://assets/audio/soul_blips/soul3.wav")
]

var interact: bool = false

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
			if index <= 9:
				sound.stream = blips
				sound.play()
			else:
				sound.stream = soul_blips[random_blips.randi_range(0, 2)]
				sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true
		
var message_debounce: bool = false

func _input(event):
	if !Inventory.ring_has_interacted and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		print(index)
		canvas_layer.visible = true
		if index == 11:
			item_give()
		if index == 18:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			Combat.player_current_health = Combat.player_max_health
			return
		message_displayed = false
		index += 1
		show_message()
		
	elif Inventory.ring_has_interacted and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		if !message_debounce:
			index = 17
		GlobalVariables.debounce = true
		canvas_layer.visible = true
		if index == 18:
			message_debounce = false
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			Combat.player_current_health = Combat.player_max_health
			return
		message_displayed = false
		index += 1
		message_debounce = true
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
