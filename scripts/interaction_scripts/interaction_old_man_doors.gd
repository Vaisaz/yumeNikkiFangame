extends Area2D

var interact: bool = false
@onready var door_sound = $DoorSound

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(_area):
	interact = false
	
func _input(_event):
	if interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !Combat.combat_layer.visible:
		Transition.playing_animation()
		await Transition.animated_sprite_2d.animation_finished
		door_sound.play()
		await door_sound.finished
		Transition.ending_animation()
		GlobalVariables.player_position = Vector2(17,14)
		get_tree().change_scene_to_file("res://scenes/locations/old_man_place.tscn")
