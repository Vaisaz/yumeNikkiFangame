extends Area2D

var messages = [
	"",
	"YOU HAVE ACQUIRED:
	BANANA"
]

var index = 0
var interact: bool = false
var message_displayed: bool = false
var interaction_times = 0

@onready var label = $"../CanvasLayer/BlankFrameBigger/Label"
@onready var canvas_layer = $"../CanvasLayer"

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(_area):
	interact = false
	
func show_message():
	if index < messages.size():
		label.text = ""
		for character in messages[index]:
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true
		
func _input(event):
	if interaction_times == 0 and interact and !Inventory.banana_has_interacted and Input.is_action_just_pressed("interact"):
		for item_count in Inventory.items:
			print(item_count)
			if Inventory.index == 0 and Inventory.items[Inventory.index].disabled and !Inventory.banana_has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[0]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[0]
				Inventory.items[Inventory.index].disabled = false
			if Inventory.index == 1 and Inventory.items[Inventory.index].disabled and !Inventory.banana_has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[0]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[0]
				Inventory.items[Inventory.index].disabled = false
			if Inventory.index == 2 and Inventory.items[Inventory.index].disabled and !Inventory.banana_has_interacted:
				Inventory.items[Inventory.index].texture_normal = Inventory.item_texture[0]
				Inventory.items[Inventory.index].texture_hover = Inventory.item_texture_hover[0]
				Inventory.items[Inventory.index].disabled = false
			if !Inventory.banana_has_interacted:
				Inventory.banana_has_interacted = true
				Inventory.index += 1
	if interaction_times == 1 and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		print(index)
		canvas_layer.visible = true
		if index == 1:
			canvas_layer.visible = false
			interaction_times = 1
			GlobalVariables.debounce = false
			return
		message_displayed = false
		index += 1
		show_message()
				
