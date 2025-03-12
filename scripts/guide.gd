extends Node

var messages = [
	"Hello and welcome to a layer of reality.",
	"The layer of reality which supplements irrationality.",
	"The layer of reality which is accessed through dreaming.",
	"The layer which makes your reality more complete.",
	"Who am I, you ask?",
	"I don't want to satisfy you with your question, so i'll end my response with just that.",
	"If you're wondering why I don't open my mouth when I talk, 
	it's because my vocal cords aren't well developed.",
	"So I transfer my thoughts to your mind.",
	"It definitely doesn't have to do with me being lazy or something!",
	"ANYWAY!",
	"I'm supposed to tell you how to dream and how to move in this layer.",
	"I think you already know how to dream, simply go to bed.",
	"To move, you can use W, A, S, D and arrow keys.",
	"To interact, you can use E, Space or Enter keys.",
	"And to wake up, you can only use M key.",
	"Movement and interaction also apply in the layer of reality in which you normally reside.",
	"What do I mean by these keys, is this a video game or something?",
	"Well, let's just break the fourth wall now.",
	"Enjoy my game!"
	]
var beeps = [
	preload("res://assets/guide/beeps/1.wav"),
	preload("res://assets/guide/beeps/2.wav"),
	preload("res://assets/guide/beeps/3.wav"),
	preload("res://assets/guide/beeps/4.wav"),
	preload("res://assets/guide/beeps/5.wav"),
	preload("res://assets/guide/beeps/6.wav"),
]

var faces = [
	preload("res://assets/guide/god/stare.png"),
	preload("res://assets/guide/god/wat.png"),
	preload("res://assets/guide/god/yippee.png"),
	preload("res://assets/guide/god/angy.png"),
	preload("res://assets/guide/god/devious.png"),
	preload("res://assets/guide/god/sad.png")
]

var random = RandomNumberGenerator.new()
var index = 0
var message_displayed = false
var can_teleport: bool = false

@onready var creator = $Stare
@onready var sound = $VBoxContainer/Sound
@onready var label = $VBoxContainer/Label

func _ready():
	show_message()

func show_message():
	if index < messages.size():
		label.text = ""
		if index == 4:
			creator.texture = faces[1]
		elif index == 5:
			creator.texture = faces[4]
		elif index == 6:
			creator.texture = faces[0]
		elif index == 9:
			creator.texture = faces[3]
		elif index == 10:
			creator.texture = faces[0]
		elif index == 16:
			creator.texture = faces[1]
		elif index == 17:
			creator.texture = faces[0]
		elif index == 18:
			creator.texture = faces[2]
			can_teleport = true
		for character in messages[index]:
			sound.stream = beeps[random.randf_range(0, 5)]
			sound.play()
			label.text += character
			await get_tree().create_timer(0.05).timeout
		message_displayed = true

func _input(event):
	if event.is_action_pressed("interact") and message_displayed:
		message_displayed = false
		if can_teleport:
			Transition.playing_animation()
			await Transition.animated_sprite_2d.animation_finished
			get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
			Transition.ending_animation()
		index += 1
		show_message()
