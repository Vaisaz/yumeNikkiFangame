extends Area2D

@onready var interaction = $"."

var player_max_health = Combat.player_max_health
var player_current_health = Combat.player_current_health

func _on_area_entered(area):
	if area.is_in_group("Player"):
		$"..".queue_free()
		GlobalVariables.debounce = true
		Combat.enemy_texture.texture = load("res://assets/combat/giggler.png")
		Combat.enemy_max_health = 100
		Combat.enemy_current_health = 100
		Combat.enemy_attack = 1
		Combat.enemy_health(Combat.enemy_current_health, Combat.enemy_max_health)
		Combat.player_health(player_current_health, player_max_health)
		print("interacted")
		Combat.combat_layer.visible = true
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
