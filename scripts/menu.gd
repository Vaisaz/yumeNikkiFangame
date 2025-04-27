extends Control

@onready var start_button = $VBoxContainer/Start
@onready var guide_button = $VBoxContainer/Guide
@onready var quit_button = $VBoxContainer/Quit

func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	start_button.grab_focus()
	start_button.texture_focused = start_button.texture_hover
	guide_button.texture_focused = guide_button.texture_hover
	quit_button.texture_focused = quit_button.texture_hover

func _on_start_pressed():
	Transition.playing_animation()
	await Transition.animated_sprite_2d.animation_finished
	get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
	Transition.ending_animation()
	GlobalVariables.debounce = false
	GlobalVariables.in_combat = false
	GlobalVariables.player_position = Vector2(-47,-43)

func _on_guide_pressed():
	GlobalVariables.debounce = false
	GlobalVariables.in_combat = false
	get_tree().change_scene_to_file("res://scenes/guide.tscn")

func _on_quit_pressed():
	get_tree().quit()
