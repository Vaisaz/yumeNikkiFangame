extends Area2D

var interact: bool = false

func _on_area_entered(area):
	if area.is_in_group("Player"):
		print("test")
		interact = true

func _on_area_exited(area):
	interact = false
	
func _input(event):
	if event.is_action_pressed("interact") and interact and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/locations/game.tscn")
