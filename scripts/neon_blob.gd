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
		animated_sprite_2d.play("push")
		await get_tree().create_timer(2).timeout
		animated_sprite_2d.play("default")
