extends Area2D

@onready var interaction = $"."
@onready var color_rect = $"../CanvasLayer/ColorRect"

var interact: bool = false
var debounce: bool = false

func _on_area_entered(area):
	if area.is_in_group("Player"):
		interact = true
		print("eh")

func _on_area_exited():
	interact = false

func _input(event):
	if Inventory.revolver_has_interacted and Inventory.toy_revolver_lv == 1 and  event.is_action_pressed("interact") and !debounce and interact and Input.is_action_just_pressed("interact") and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false:
		debounce = true
		GlobalVariables.in_combat = true
		GlobalVariables.debounce = true
		for n in 128:
			color_rect.color = Color8(0, 0, 0, n*2)
			set_process(false)
			await get_tree().create_timer(0.01).timeout
			set_process(true)
		get_tree().change_scene_to_file("res://scenes/clown_combat.tscn")
