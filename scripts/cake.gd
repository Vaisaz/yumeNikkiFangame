extends Area2D

func _physics_process(delta):
	position.y += 50 * delta

func _on_area_entered(area: Area2D):
	
	if area.is_in_group("Creature"):
		$".".queue_free()
		GlobalVariables.cake_falling = true
		GlobalVariables.cake_score += 10
		
	if area.is_in_group("Grass"):
		GlobalVariables.player_position = Vector2(15, -46)
		get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
