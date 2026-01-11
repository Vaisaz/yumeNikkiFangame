"""
extends Area2D

var interact: bool = false

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(area):
	interact = false
		
func _input(event):
	if interact and Input.is_action_just_pressed("interact"):
		print("pressed")
"""

extends Area2D

var interact: bool = false

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(_area):
	interact = false
	
func _input(_event):
	if interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false:
		Transition.playing_animation()
		await Transition.animated_sprite_2d.animation_finished
		Transition.ending_animation()
		get_tree().change_scene_to_file("res://scenes/locations/name.tscn")
