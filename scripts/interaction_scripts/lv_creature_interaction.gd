extends Area2D

var messages = [
	"",
	"HENLO...",
	"HOW DID I GET HERE?",
	"WHERE AM I-",
	"YOU CAN UPGRADE YOUR ITEMS ON MY COMPUTER!",
	"GET NEAR THE COMPUTER AND GO TO YOUR
	INVENTORY!",
	"ONCE THERE, YOU CAN CLICK ON ANY ITEM AND
	IT'LL LEVEL UP IF YOU HAVE ENOUGH MONEY!",
	"TO CHECK THE PRICE YOU CAN INTERACT WITH
	THE COMPUTER!",
	"WHY DO I SCREAM SO MUCH?
	.  .  .",
	"WHAT DID I JUST SAY?",
	".  .  ."
]

var blips = load("res://assets/audio/lv_creature_blips/lv_creature_blip.wav")

var index = 0
var interact: bool = false
var message_displayed: bool = false
var interaction_times = 0
var random = RandomNumberGenerator.new()

@onready var label = $"../CanvasLayer/BlankFrameBigger/Label"
@onready var canvas_layer = $"../CanvasLayer"
@onready var sound = $"../Sound"

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
	if index == 0:
		message_displayed = true
		
func _on_area_exited(_area):
	interact = false
	
func show_message():
	if index < messages.size():
		label.text = ""
		for character in messages[index]:
			sound.stream = blips
			sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true
		
func _input(event):
	if interaction_times == 0 and interact and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !Inventory.all_items_enabled:
		GlobalVariables.debounce = true
		canvas_layer.visible = true
		if index == 9:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			interaction_times = 1
			return
		message_displayed = false
		index += 1
		show_message()
	elif interaction_times == 1 and interact and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !Inventory.all_items_enabled:
		GlobalVariables.debounce = true
		canvas_layer.visible = true
		if index == 10:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			index = 9
			return
		message_displayed = false
		index += 1
		show_message()
