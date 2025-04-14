extends CharacterBody2D

@onready var player = $"../CharacterBody2D"
@onready var enemy_radius = $EnemyRadius
var speed = 25
var interact: bool = false

func _on_enemy_radius_area_entered(area):
	if area.is_in_group("Player"):
		print("entered")
		interact = true

func _on_enemy_radius_area_exited(area):
	interact = false
	print("exited")

func _physics_process(_delta):
	var direction = (player.position-position).normalized()
	if interact:
		velocity = direction * speed
	if !interact:
		velocity = direction * 0
	if !GlobalVariables.in_combat:
		move_and_slide()

#func _process(delta):
	#if Transition.canvas_layer.visible and Transition.animated_sprite_2d.visible and !Transition.combat_transition_animation.visible and !Transition.visibility and !GlobalVariables.in_combat:
		#Transition.transitions += 1
		#print(Transition.transitions)
		#if Transition.transitions == 1:
			#Transition.visibility = true
		#if Transition.transitions == 2:
			#print("1 yes")
			#Transition.transitions = 0
			#$".".queue_free()
	#elif !Transition.canvas_layer.visible:
		#Transition.visibility = false
