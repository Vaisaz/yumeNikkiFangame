extends Area2D

var interact: bool = false
var debounce: bool = false
@onready var loading_animation = $"../CanvasLayer/AnimatedSprite2D"
@onready var canvas_layer = $"../CanvasLayer"

func _input(event):
	if event.is_action_pressed("interact") and interact and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !debounce:
		debounce = true
		GlobalVariables.in_combat = true
		canvas_layer.visible = true
		loading_animation.play("default")
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("ui_cancel") and debounce:
		debounce = false
		GlobalVariables.in_combat = false
		canvas_layer.visible = false
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)

func _on_area_entered(area: Area2D) -> void:
	GlobalVariables.wp_lv_enable = 1
	if area.is_in_group("Player"):
		interact = true
		print("area entered")

func _on_area_exited(area: Area2D) -> void:
	GlobalVariables.wp_lv_enable = 0
	interact = false
