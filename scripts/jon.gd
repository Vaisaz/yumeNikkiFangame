extends CharacterBody2D

@export var speed = 50
@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(_delta):
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	var input_direction = Vector2(x_axis, y_axis)
	if input_direction == Vector2(0, 0):
		animated_sprite_2d.play("idle")
	elif input_direction == Vector2(0, -1):
		animated_sprite_2d.play("up")
	elif input_direction == Vector2(0, 1):
		animated_sprite_2d.play("down")
	elif input_direction == Vector2(-1, 0):
		animated_sprite_2d.play("left")
	elif input_direction == Vector2(1, 0):
		animated_sprite_2d.play("right")
		
	velocity = input_direction * speed
	
	move_and_slide()

func _input(_event):
	if Input.is_action_just_pressed("wake_up") and !get_tree().current_scene.scene_file_path == "res://scenes/locations/room.tscn":
		get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
