extends Area2D

var interact: bool = false

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(_area):
	interact = false
	
func _input(_event):
	if interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !Combat.combat_layer.visible:
		if get_tree().current_scene.scene_file_path == "res://scenes/locations/number_dream.tscn":
			GlobalVariables.player_position = Vector2(346,-201)
			Transition.playing_animation()
			await Transition.animated_sprite_2d.animation_finished
			Transition.ending_animation()
			get_tree().change_scene_to_file("res://scenes/locations/random_dream.tscn")
		elif get_tree().current_scene.scene_file_path == "res://scenes/locations/random_dream.tscn":
			GlobalVariables.player_position = Vector2(-66,254)
			Transition.playing_animation()
			await Transition.animated_sprite_2d.animation_finished
			Transition.ending_animation()
			get_tree().change_scene_to_file("res://scenes/locations/number_dream.tscn")
