extends CharacterBody2D

@onready var player = $"../CharacterBody2D"
var speed = 25

func _ready():
	pass

func _physics_process(_delta):
	var direction = (player.position-position).normalized()
	velocity = direction * speed
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
