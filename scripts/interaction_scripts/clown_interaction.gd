extends Area2D

@onready var interaction = $"."
@onready var color_rect = $"../CanvasLayer/ColorRect"

var interact: bool = false

var player_max_health = Combat.player_max_health
var player_current_health = Combat.player_current_health

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		print("eh")

func _on_area_exited(_area):
	interact = false

func _input(area):
	if Input.is_action_just_pressed("interact") and interact:
		for n in 128:
			color_rect.color = Color8(0, 0, 0, n*2)
			set_process(false)
			await get_tree().create_timer(0.01).timeout
			set_process(true)
		get_tree().change_scene_to_file("res://scenes/clown_combat.tscn")
