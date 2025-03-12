extends CharacterBody2D

@export var speed = 50
@onready var animated_sprite_2d = $AnimatedSprite2D

var transitioning: bool = false

func _physics_process(_delta):
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	var input_direction = Vector2(x_axis, y_axis)
	if Transition.canvas_layer.visible == true:
		transitioning = true
		animated_sprite_2d.play("idle")
		input_direction = Vector2(0, 0)
		Transition.wait()
	else:
		transitioning = false
		if input_direction == Vector2(0, 0):
			animated_sprite_2d.stop()
		elif input_direction == Vector2(0, -1):
			animated_sprite_2d.play("up")
		elif input_direction == Vector2(0, 1):
			animated_sprite_2d.play("down")
		elif input_direction == Vector2(-1, 0):
			animated_sprite_2d.play("left")
		elif input_direction == Vector2(1, 0):
			animated_sprite_2d.play("right")
		elif input_direction == Vector2(1, 1):
			input_direction = Vector2(0, 0)
			animated_sprite_2d.play("idle")
		elif input_direction == Vector2(1, -1):
			input_direction = Vector2(0, 0)
			animated_sprite_2d.play("idle")
		elif input_direction == Vector2(-1, 1):
			input_direction = Vector2(0, 0)
			animated_sprite_2d.play("idle")
		elif input_direction == Vector2(-1, -1):
			input_direction = Vector2(0, 0)
			animated_sprite_2d.play("idle")
		
		velocity = input_direction * speed
	
	if !transitioning:
		move_and_slide()

func _input(_event):
	if Input.is_action_just_pressed("wake_up") and !get_tree().current_scene.scene_file_path == "res://scenes/locations/room.tscn" and Transition.canvas_layer.visible == false:
		Transition.playing_animation()
		await Transition.animated_sprite_2d.animation_finished
		Transition.waking_sleeping_2d.visible = true
		Transition.waking_sleeping_2d.play("waking")
		await Transition.waking_sleeping_2d.animation_finished
		Transition.waking_sleeping_2d.visible = false
		get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
		Transition.ending_animation()
