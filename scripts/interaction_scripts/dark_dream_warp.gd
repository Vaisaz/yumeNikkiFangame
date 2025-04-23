extends Area2D

var interact: bool = false
@onready var door_sound = $DoorSound

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		
func _on_area_exited(_area):
	interact = false
	
func _input(_event):
	if interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !Combat.combat_layer.visible:
		Transition.playing_animation()
		GlobalVariables.in_combat = true
		GlobalVariables.debounce = true
		await Transition.animated_sprite_2d.animation_finished
		Transition.waking_sleeping_2d.visible = true
		Transition.waking_sleeping_2d.play("falling")
		var sound = AudioStreamPlayer.new()
		add_child(sound)
		sound.stream = load("res://assets/audio/falling_sound.wav")
		sound.play()
		await Transition.waking_sleeping_2d.animation_finished
		sound.stream = load("res://assets/audio/fell_sound.wav")
		sound.play()
		await get_tree().create_timer(0.1).timeout
		Transition.waking_sleeping_2d.visible = false
		get_tree().change_scene_to_file("res://scenes/locations/dark_dream.tscn")
		GlobalVariables.player_position = Vector2(208,21)
		GlobalVariables.in_combat = false
		GlobalVariables.debounce = false
		Transition.ending_animation()
