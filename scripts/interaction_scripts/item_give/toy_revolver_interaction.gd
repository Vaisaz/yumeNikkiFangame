extends Area2D

var messages = [
	"",
	"YOU HAVE ACQUIRED:
	TOY REVOLVER",
	"GIVES AND TAKES:
	0 HP
	+50 AT"
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
			sound.stream =soul_blips[random.randi_range(0, 2)]
			sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true
		
func _input(event):
	if !Inventory.revolver_has_interacted:
		Inventory.items_disabled_checker()
	if interaction_times == 0 and interact and !Inventory.revolver_has_interacted and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !Inventory.all_items_enabled:
		GlobalVariables.debounce = true
		GlobalVariables.interacting = true
		canvas_layer.visible = true
		if index == 2:
			GlobalVariables.interacting = false
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			interaction_times = 1
			return
		message_displayed = false
		index += 1
		show_message()
	if interaction_times == 1 and interact and !Inventory.revolver_has_interacted:
		if Inventory.index >= 12:
			return
		else:
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
				Inventory.index += 1
			Inventory.index = 0

func item_give_structure():
	if Inventory.items[Inventory.index].disabled and !Inventory.revolver_has_interacted:
		Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[7]
		Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[7]
		Inventory.items[Inventory.index].disabled = false
		Inventory.revolver_has_interacted = true
		$"../Sprite2D".visible = false
