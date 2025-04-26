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
	if !GlobalVariables.in_combat and !GlobalVariables.debounce:
		move_and_slide()
