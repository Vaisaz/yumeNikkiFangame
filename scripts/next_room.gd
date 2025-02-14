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
