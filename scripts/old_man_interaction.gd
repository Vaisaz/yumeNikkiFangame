extends Area2D

var messages = [
	"",
	"IT HAS BEEN A LONG TIME SINCE I SAW SOMEONE
	DOWN HERE",
	"IT IS NOT IMPOSSIBLE TO GET HERE",
	"HOWEVER, IT IS TOUGHT TO GET OUT",
	"IT REQUIRES SOMETHING YOU HAVE FORGOTTEN",
	"IT REQUIRES SOMETHING YOU HAVE LOST",
	"CAN YOU REMEMBER IT?",
	"CAN YOU FIND IT?",
	"I SHALL HELP YOU FIND AND REMEMBER"
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
	if interaction_times == 0 and interact and event.is_action_pressed("interact") and message_displayed and interact and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		GlobalVariables.debounce = true
		GlobalVariables.in_combat = true
		canvas_layer.visible = true
		if index == 8:
			canvas_layer.visible = false
			GlobalVariables.debounce = false
			GlobalVariables.in_combat = false
			interaction_times = 1
			return
		message_displayed = false
		index += 1
		show_message()
	if interaction_times == 1 and interact and interact:
		Inventory.add_coins = 0
		GlobalVariables.in_combat = true
		Transition.combat_transition_animation.visible = true
		Transition.combat_transition_animation.play("default")
		Transition.canvas_layer.visible = true
		Transition.animated_sprite_2d.visible = false
		await Transition.combat_transition_animation.animation_finished
		Transition.combat_transition_animation.visible = false
		Transition.canvas_layer.visible = false
		Transition.animated_sprite_2d.visible = true
		$"..".queue_free()
		GlobalVariables.debounce = true
		Combat.enemy_texture.texture = load("res://assets/combat/old_man_sprite_sheet.png")
		Combat.combat_sound.stream = load("res://assets/audio/old_man_blips/ringsuf.mp3")
		Combat.enemy_max_health = 2000
		Combat.enemy_current_health = 2000
		Combat.enemy_attack = 50
		Combat.enemy_health(Combat.enemy_current_health, Combat.enemy_max_health)
		Combat.player_health()
		print("interacted")
		Combat.combat_layer.visible = true
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		Combat.combat_sound.play()
