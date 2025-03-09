extends CanvasLayer

var interact: bool = false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var canvas_layer = $"."

func playing_animation():
	canvas_layer.visible = true
	animated_sprite_2d.play("default")
	
func wait():
	await animated_sprite_2d.animation_finished
	
func ending_animation():
	animated_sprite_2d.play("second")
	await animated_sprite_2d.animation_finished
	canvas_layer.visible = false
