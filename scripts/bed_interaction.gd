extends Area2D

var interact: bool = false
@onready var canvas_layer = $CanvasLayer
@onready var animated_sprite_2d = $CanvasLayer/AnimatedSprite2D2

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(_area):
	interact = false
		
func _input(_event):
	if interact and Input.is_action_just_pressed("interact"):
		canvas_layer.visible = true
		animated_sprite_2d.play("default")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("second")
		canvas_layer.visible = false
		get_tree().change_scene_to_file("res://scenes/locations/dream_room.tscn")
