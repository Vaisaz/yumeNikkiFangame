extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
const SPEED = 45.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		animated_sprite.play("run")
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.play("run")
		animated_sprite.flip_h = false
	else:
		animated_sprite.play("idle")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
