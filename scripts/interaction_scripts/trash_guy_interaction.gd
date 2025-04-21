extends Area2D

var messages = [
	"",
	".  .  .",
	"IF YOU WANT TO GET RID OF YOUR STUFF,
	INTERACT AGAIN"
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
			sound.stream =soul_blips[random.randi_range(0, 2)]
			sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true
		
func _input(event):
	if interaction_times == 0 and interact and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		if Inventory.trash_has_interacted:
			interaction_times = 1
			return
		GlobalVariables.debounce = true
		GlobalVariables.in_combat = true
		canvas_layer.visible = true
		if index == 2:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			GlobalVariables.in_combat = false
			interaction_times = 1
			message_displayed = true
		else:
			message_displayed = false
			index += 1
			show_message()
	elif interaction_times == 1 and message_displayed and event.is_action_pressed("interact") and interact and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		if Inventory.index >= 12:
			register_sound.play()
		for item_count in 12:
			Inventory.items[item_count].texture_normal = null
			Inventory.items[item_count].texture_hover = null
			Combat.items[item_count].texture_normal = null
			Combat.items[item_count].texture_hover = null
			Combat.items[item_count].disabled = true
			Inventory.items[item_count].disabled = true
			Inventory.trash_has_interacted = true
			Inventory.banana_has_interacted = false
			Inventory.watches_has_interacted = false
			Inventory.dice_has_interacted = false
			Inventory.wnp_has_interacted = false
			print(item_count)
		print("not part of loop")
		Inventory.index = 0
		interaction_times = 2
		print(Inventory.index)
				
		if interaction_times == 2 and message_displayed and interact and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
			interaction_times = 0
