extends Area2D

@onready var interaction = $"."

var player_max_health = Combat.player_max_health
var player_current_health = Combat.player_current_health

func _on_area_entered(area):
	if area.is_in_group("Player"):
		Inventory.add_coins = 5
		GlobalVariables.in_combat = true
		Transition.combat_transition_animation.visible = true
		Transition.combat_transition_animation.play("default")
		Transition.canvas_layer.visible = true
		Transition.animated_sprite_2d.visible = false
		await Transition.combat_transition_animation.animation_finished
		Transition.combat_transition_animation.visible = false
		Transition.canvas_layer.visible = false
		Transition.animated_sprite_2d.visible = true
		$"..".queue_free()
		GlobalVariables.debounce = true
		Combat.enemy_texture.texture = load("res://assets/combat/giggler.png")
		Combat.enemy_max_health = 100
		Combat.enemy_current_health = 100
		Combat.enemy_attack = 1
		Combat.enemy_health(Combat.enemy_current_health, Combat.enemy_max_health)
		Combat.player_health()
		print("interacted")
		Combat.combat_layer.visible = true
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

