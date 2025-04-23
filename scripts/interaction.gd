extends CanvasLayer

var interact: bool = false
var transitioning:bool = false
var visibility: bool = false
var transitions = 0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var canvas_layer = $"."
@onready var waking_sleeping_2d = $WakingSleeping
@onready var combat_transition_animation = $CombatTransitionAnimation
@onready var color_rect = $ColorRect
@onready var sound = $Sound

func playing_animation():
	canvas_layer.visible = true
	animated_sprite_2d.play("default")
	
func wait():
	await animated_sprite_2d.animation_finished
	
func ending_animation():
	animated_sprite_2d.play("second")
	await animated_sprite_2d.animation_finished
	canvas_layer.visible = false
	
func ending_animation_full():
	canvas_layer.visible = true
	animated_sprite_2d.play("second")
	await animated_sprite_2d.animation_finished
	canvas_layer.visible = false	
	
#func playing_combat_transition_animation():
	#canvas_layer.visible = true
	#animated_sprite_2d.visible = false
	#combat_transition_animation.play("default")
	#await combat_transition_animation.animation_finished
	#animated_sprite_2d.visible = true
	#canvas_layer.visible = false
