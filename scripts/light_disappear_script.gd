extends CanvasModulate

@onready var door = $"../StaticBody2D"
@onready var door_animation = $"../StaticBody2D/AnimatedSprite2D"
@onready var light = $PointLight2D2

func _ready():
	await door_animation.animation_finished
	light.queue_free()
	door.queue_free()
