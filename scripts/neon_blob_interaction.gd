extends Area2D

var interact: bool = false
@onready var animated_sprite_2d = $"../AnimatedSprite2D"

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(_area):
	interact = false
		
func _input(_event):
	if interact and Input.is_action_just_pressed("interact"):
		interact = false
		animated_sprite_2d.play("pushed")
		await get_tree().create_timer(1).timeout
		animated_sprite_2d.play("default")
		interact = true

