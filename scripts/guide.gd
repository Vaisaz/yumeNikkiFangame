extends Node

var messages = [
	"HELLO AND WELCOME TO A LAYER OF REALITY.",
	"THE LAYER OF REALITY WHICH SUPPLEMENTS IRRATIONALITY.",
	"THE LAYER OF REALITY WHICH IS ACCESSED THROUGH DREAMING.",
	"THE LAYER WHICH MAKES YOUR REALITY MORE COMPLETE.",
	"WHO AM I, YOU ASK?",
	"I DON'T WANT TO SATISFY YOU WITH YOUR QUESTION, SO I'LL
	END MY RESPONSE WITH JUST THAT.",
	"IF YOU'RE WONDERING WHY I DON'T OPEN MY MOUTH WHEN I TALK,
	IT'S BECAUSE MY VOCAL CORDS AREN'T WELL DEVELOPED.",
	"SO I TRANSFER MY THOUGHTS TO YOUR MIND.",
	"IT DEFINITELY DOESN'T HAVE TO DO WITH ME BEING LAZY OR
	SOMETHING!",
	"ANYWAY!",
	"I'M SUPPOSED TO TELL YOU HOW TO DREAM AND HOW TO MOVE
	IN THIS LAYER.",
	"I THINK YOU ALREADY KNOW HOW TO DREAM, SIMPLY GO TO BED.",
	"TO MOVE, YOU CAN USE W, A, S, D AND ARROW KEYS.",
	"TO INTERACT, YOU CAN USE E, SPACE OR ENTER KEYS.",
	"TO OPEN YOUR INVENTORY WHILE DREAMING, YOU CAN USE ESC KEY.",
	"AND TO WAKE UP, YOU CAN ONLY USE M KEY.",
	"MOVEMENT AND INTERACTION ALSO APPLY IN THE LAYER OF REALITY
	IN WHICH YOU NORMALLY RESIDE.",
	"WHAT DO I MEAN BY THESE KEYS, IS THIS A VIDEO GAME OR SOMETHING?",
	"WELL, LET'S JUST BREAK THE FOURTH WALL NOW.",
	"ENJOY MY GAME!"
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
var message_displayed: bool = false
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
		elif index == 17:
			creator.texture = faces[1]
		elif index == 18:
			creator.texture = faces[0]
		elif index == 19:
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
