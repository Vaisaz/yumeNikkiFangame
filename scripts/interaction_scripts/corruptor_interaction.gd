extends Area2D

var messages = [
	"",
	"IT HAS BEEN A LONG TIME SINCE SOMEONE
	ENTERED MY JAIL",
	"WHAT WOULD YOU SAY TO A DEAL THAT COULD
	CHANGE YOUR LIFE?",
	"WITH A GRANDIOSE POSITIVE OUTCOME BUT
	TURNING INTO SOMEONE YOU HATED THE MOST?",
	"IMAGINE THAT YOU COULD REACH ALL OF YOUR
	DREAMS",
	"SATISFIED, RIGHT?",
	"BUT YOU WILL BE STARVING AND NOTHING WILL
	PLEASE YOU ENTIRELY",
	"SO YOU WILL FEAST ON ALL OF THOSE REACHED
	DREAMS LIKE A PIG ONLY FOR THEM TO BE LEFT
	TO ROT IN A BURNING MEMORY OF YOURS",
	"NOT CARING AND HAVING ANY THOUGHT ON HOW
	THEY TASTED BACK THEN",
	"THAT IS NOTHING NEW HOWEVER, IS IT?",
	"I CAN SEE IT IN YOUR EYES THAT YOU HAVE BEEN
	PUSHED INTO THE VOID",
	"GIVE UP AND BECOME ABSORBED",
	"BECOME MY PUPPET, LOSE AND RISE",
	"J	O	N",
	"YOU HAVE ACQUIRED CORRUPTION",
	"GIVES AND TAKES
	POWER
	YOUR SOUL",
	"FINALLY A GREAT FEAST"
]

var blips = [
	load("res://assets/audio/corruptor_blips/blip.wav")
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
		sound.stream = blips[0]
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
			if index <= 13:
				label.add_theme_color_override("font_color", Color8(165, 0, 0))
				sound.stream = blips[0]
				sound.play()
			if index > 13 and index < 16:
				label.add_theme_color_override("font_color", Color8(255, 255, 255))
				sound.stream = soul_blips[random_blips.randi_range(0, 2)]
				sound.play()
			if index == 16:
				label.add_theme_color_override("font_color", Color8(165, 0, 0))
				sound.stream = blips[0]
				sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true

func _input(event):
	if interaction_times == 0 and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		print(index)
		canvas_layer.visible = true
		GlobalVariables.interacting = true
		if index == 13:
			GlobalVariables.interacting = false
			canvas_layer.visible = false
			interaction_times = 1
			GlobalVariables.debounce = false
			return
		message_displayed = false
		index += 1
		show_message()
	if interaction_times == 1 and event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		print(index)
		canvas_layer.visible = true
		GlobalVariables.interacting = true
		if index == 16:
			item_give()
			Inventory.corruption_interaction()
			Inventory.corruption_has_interacted = true
			GlobalVariables.interacting = false
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			return
		message_displayed = false
		index += 1
		show_message()

func item_give():
	Inventory.equipped.texture = load("res://assets/inventory/items/corruption.png")
	Inventory.normal_health()
	Combat.player_attack += 50
	Combat.player_max_health += 50
	Inventory.banana_equipped = false
	Inventory.watches_equipped = false	
	Inventory.wnp_equipped = false
	Inventory.dice_equipped = false
	Inventory.index = 0
	for item_count in 12:
		if !Inventory.items[item_count].texture_normal == null:
			Inventory.items[item_count].texture_normal = null
			Inventory.items[item_count].texture_hover = null
			Combat.items[item_count].texture_normal = null
			Combat.items[item_count].texture_hover = null
			Combat.items[item_count].disabled = true
			Inventory.items[item_count].disabled = true
			Inventory.banana_has_interacted = false
			Inventory.watches_has_interacted = false
			Inventory.dice_has_interacted = false
			Inventory.wnp_has_interacted = false
			break
		print(Inventory.index)
	Inventory.index = 0
	for item_count in 12:
		if Inventory.index == 0:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 1:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 2:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 3:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 4:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 5:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 6:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 7:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 8:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 9:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 10:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
		if Inventory.index == 11:
			Inventory.items[item_count].texture_normal = Inventory.item_texture[5]
			Inventory.items[item_count].texture_hover = Inventory.item_texture_hover[5]
			Inventory.items[item_count].disabled = false
