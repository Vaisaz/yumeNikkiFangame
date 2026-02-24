extends Area2D

var interact: bool = false
var debounce: bool = false
@onready var loading_animation = $"../CanvasLayer/AnimatedSprite2D"
@onready var canvas_layer = $"../CanvasLayer"
@onready var scroll_container = $"../CanvasLayer/ScrollContainer"
@onready var audio = $"../Sound"

@onready var wnp_label = $"../CanvasLayer/ScrollContainer/VBoxContainer/WNP/WNPLabel"
@onready var banana_label = $"../CanvasLayer/ScrollContainer/VBoxContainer/Banana/BananaLabel"
@onready var toy_revolver_label = $"../CanvasLayer/ScrollContainer/VBoxContainer/ToyRevolver/ToyRevolverLabel"

func _input(event):
	if event.is_action_pressed("interact") and interact and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !debounce:
		
		if Inventory.wnp_has_interacted:
			wnp_label.text = "WNPV10.127"
		else:
			wnp_label.text = "?"
			print("wnp")
			
		if Inventory.banana_has_interacted:
				wnp_label.text = "BANANA"
		else:
			wnp_label.text = "?"
			print("banana")
			
		if Inventory.revolver_has_interacted:
			wnp_label.text = "TOY REVOLVER"
		else:
			wnp_label.text = "?"
			print("revolver")
		
		debounce = true
		GlobalVariables.in_combat = true
		GlobalVariables.interacting = true
		GlobalVariables.debounce = true
		canvas_layer.visible = true
		loading_animation.play("default")
		await loading_animation.animation_finished
		scroll_container.visible = true
		audio.play()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
			
	elif event.is_action_pressed("ui_cancel") and debounce:
		audio.stop()
		scroll_container.visible = false
		debounce = false
		GlobalVariables.in_combat = false
		GlobalVariables.debounce = false
		GlobalVariables.interacting = false
		canvas_layer.visible = false
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		interact = true

func _on_area_exited(_area: Area2D) -> void:
	GlobalVariables.wp_lv_enable = 0
	interact = false
