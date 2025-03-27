extends CharacterBody2D

@onready var player = $"../CharacterBody2D"
var speed = 25

func _physics_process(delta):
	if Transition.canvas_layer.visible:
		$".".queue_free()
	var direction = (player.position-position).normalized()
	velocity = direction * speed
	move_and_slide()
