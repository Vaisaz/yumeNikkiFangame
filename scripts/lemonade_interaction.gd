extends Area2D

var messages = [
	"",
	"YOU HAVE ACQUIRED:
	LEMONADE",
	"GIVES AND TAKES:
	+25 HP
	0 AT"
]

var index = 0
var interact: bool = false
var message_displayed: bool = false
var interaction_times = 0
var has_interacted: bool = false

@onready var label = $"../CanvasLayer/BlankFrameBigger/Label"
@onready var canvas_layer = $"../CanvasLayer"

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
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true
		
func _input(event):
	if interaction_times == 0 and interact and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		if has_interacted:
			interaction_times = 1
			has_interacted = false
			return
		print("works")
		GlobalVariables.debounce = true
		GlobalVariables.in_combat = true
		canvas_layer.visible = true
		if index == 2:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			GlobalVariables.in_combat = false
			interaction_times = 1
			return
		message_displayed = false
		index += 1
		show_message()
	if interaction_times == 1 and message_displayed and interact and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and Inventory.coins >= 0:
		for item_count in Inventory.items:
			print(item_count)
			if Inventory.index == 0 and Inventory.items[Inventory.index].disabled and !has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[3]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[3]
				Inventory.items[Inventory.index].disabled = false
			if Inventory.index == 1 and Inventory.items[Inventory.index].disabled and !has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[3]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[3]
				Inventory.items[Inventory.index].disabled = false
			if Inventory.index == 2 and Inventory.items[Inventory.index].disabled and !has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[3]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[3]
				Inventory.items[Inventory.index].disabled = false
			if !has_interacted:
				has_interacted = true
				Inventory.coins -= 5
				interaction_times = 2
				Inventory.index += 1
				
