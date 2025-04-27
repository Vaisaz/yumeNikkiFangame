extends Area2D

var messages = [
	"",
	"YOU HAVE TO FEED ME TO LEVEL 5 IN ORDER TO 
	ACCESS THESE DOORS."
]

var interact: bool = false
@onready var door_sound = $DoorSound

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(_area):
	interact = false
	
var entered: bool = false

var soul_blips = [
	load("res://assets/audio/soul_blips/soul1.wav"),
	load("res://assets/audio/soul_blips/soul2.wav"),
	load("res://assets/audio/soul_blips/soul3.wav")
]

var index = 0
var message_displayed: bool = true
var random = RandomNumberGenerator.new()

@onready var label = $"../CanvasLayer/BlankFrameBigger/Label"
@onready var canvas_layer = $"../CanvasLayer"
@onready var sound = $"../Sound"

func show_message():
	if index < messages.size():
		label.text = ""
		for character in messages[index]:
			sound.stream = soul_blips[random.randi_range(0, 2)]
			sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true

func _input(event):
	if event.is_action_pressed("interact") and message_displayed and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		canvas_layer.visible = true
		if index == 1:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			return
		message_displayed = false
		index += 1
		show_message()
	elif Combat.lv == 5 and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !Combat.combat_layer.visible:
		Transition.playing_animation()
		await Transition.animated_sprite_2d.animation_finished
		door_sound.play()
		await door_sound.finished
		Transition.ending_animation()
		GlobalVariables.player_position = Vector2(2920,136)
		get_tree().change_scene_to_file("res://scenes/locations/happy_dream.tscn")
	
