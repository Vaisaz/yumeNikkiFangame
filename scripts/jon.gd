extends CharacterBody2D

@export var speed = 200
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var walk_sound = $Sound
@onready var step_timer = $StepTimer

var transitioning: bool = false

func _physics_process(_delta):
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	var input_direction = Vector2(x_axis, y_axis)
	if Transition.canvas_layer.visible:
		velocity = input_direction * 0
		transitioning = true
		animated_sprite_2d.play("idle")
		input_direction = Vector2(0, 0)
		Transition.wait()
	elif Inventory.inventory_layer.visible:
		velocity = input_direction * 0
		input_direction = Vector2(0, 0)
	elif GlobalVariables.debounce:
		velocity = input_direction * 0
		animated_sprite_2d.stop()
		input_direction = Vector2(0, 0)
	else:
		if GlobalVariables.outfit == 1:
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
		elif GlobalVariables.outfit == 2:
			$Camera2D.enabled = false
			$"../EndingCamera".enabled = true
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
		
		if GlobalVariables.debounce:
			velocity = input_direction * 0
		else:
			velocity = input_direction * speed
		
	if !transitioning or !GlobalVariables.debounce:
		move_and_slide()

var inventory_pressed = false	

func _input(_event):
	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		pass
	if Input.is_action_just_pressed("wake_up") and !get_tree().current_scene.scene_file_path == "res://scenes/locations/room.tscn" and !Transition.canvas_layer.visible and !GlobalVariables.debounce and !Inventory.inventory_layer.visible:
		if GlobalVariables.outfit == 2:
			GlobalVariables.in_combat = true
			Transition.combat_transition_animation.visible = true
			Transition.combat_transition_animation.play("default")
			Transition.canvas_layer.visible = true
			Transition.animated_sprite_2d.visible = false
			await Transition.combat_transition_animation.animation_finished
			Transition.combat_transition_animation.visible = false
			Transition.canvas_layer.visible = false
			Transition.animated_sprite_2d.visible = true
			GlobalVariables.debounce = true
			Combat.player_current_health = Combat.player_max_health
			Combat.player_attack = 0
			Combat.enemy_max_health = Combat.player_max_health
			Combat.enemy_current_health = Combat.player_max_health
			Combat.enemy_texture.texture = load("res://assets/inventory/dream_eye/1.png")
			Combat.enemy_attack = Combat.player_max_health - 1
			Combat.enemy_health(Combat.enemy_current_health, Combat.enemy_max_health)
			Combat.player_health()
			Combat.combat_layer.visible = true
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		else:
			GlobalVariables.player_position = Vector2(-47,-43)
			Transition.playing_animation()
			GlobalVariables.in_combat = true
			GlobalVariables.debounce = true
			await Transition.animated_sprite_2d.animation_finished
			Transition.waking_sleeping_2d.visible = true
			Transition.waking_sleeping_2d.play("waking")
			await Transition.waking_sleeping_2d.animation_finished
			Transition.waking_sleeping_2d.visible = false
			get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
			GlobalVariables.in_combat = false
			GlobalVariables.debounce = false
			Transition.ending_animation()
	if Input.is_action_just_pressed("inventory") and !get_tree().current_scene.scene_file_path == "res://scenes/locations/room.tscn" and !GlobalVariables.in_combat:
		if !inventory_pressed:
			GlobalVariables.debounce = true
			Inventory.inventory_layer.visible = true
			Inventory.soul_button.grab_focus()
			inventory_pressed = true
		else:
			GlobalVariables.debounce = false
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
			Inventory.inventory_layer.visible = false
			Inventory.soul_choosed.visible = false
			Inventory.quit_choosed.visible = false
			Inventory.inventory_choosed.visible = false
			inventory_pressed = false
			
func _process(_delta):
	if get_tree().current_scene != GlobalVariables.current_scene:
		$".".global_position = GlobalVariables.player_position
	GlobalVariables.current_scene = get_tree().current_scene
