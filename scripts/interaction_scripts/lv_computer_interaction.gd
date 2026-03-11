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

@onready var wnp_stats_label = $"../CanvasLayer/ScrollContainer/VBoxContainer/WNP/WNPStatsLabel"
@onready var banana_stats_label = $"../CanvasLayer/ScrollContainer/VBoxContainer/Banana/BananaStatsLabel"
@onready var toy_revolver_stats_label = $"../CanvasLayer/ScrollContainer/VBoxContainer/ToyRevolver/ToyRevolverStatsLabel"

func _input(event):
	if event.is_action_pressed("interact") and interact and Transition.canvas_layer.visible == false and Inventory.inventory_layer.visible == false and !debounce:
		
		if Inventory.wnp_has_interacted:
			wnp_label.text = "WNPV10.127"
			if Inventory.wnp_level == 0:
				wnp_stats_label.text = " LV: 0 >> 1
 AT: 25 >> 30
 CO: %d >> %d" % [Inventory.coins, Inventory.coins-150]
			elif Inventory.wnp_level == 1:	
				wnp_stats_label.text = " LV: 1 >> 2
 AT: 30 >> 40
 CO: %d >> %d" % [Inventory.coins, Inventory.coins-350]
			elif Inventory.wnp_level == 2:	
				wnp_stats_label.text = " LV: 2
 AT: 40"
		else:
			wnp_label.text = "?"
			
		if Inventory.banana_has_interacted:
			banana_label.text = "BANANA"
			if Inventory.banana_level == 0:
				banana_stats_label.text = " LV: 0 >> 1
 HP: 50 >> 55
 AT: -5
 CO: %d >> %d" % [Inventory.coins, Inventory.coins-100]
			elif Inventory.banana_level == 1:	
				banana_stats_label.text = " LV: 1 >> 2
 HP: 55 >> 70
 AT: -5 >> 10
 CO: %d >> %d" % [Inventory.coins, Inventory.coins-250]
			elif Inventory.banana_level == 2:	
				banana_stats_label.text = " LV: 2
 HP: 70
 AT: 10"
		else:
			banana_label.text = "?"
			
		if Inventory.revolver_has_interacted:
			if Inventory.toy_revolver_level == 0:
				toy_revolver_label.text = "TOY
REVOLVER"
				toy_revolver_stats_label.text = " LV: 0 >> 1
 AT: 35 >> 0
 CO: %d >> %d" % [Inventory.coins, Inventory.coins-500]
			elif Inventory.toy_revolver_level == 1:	
				toy_revolver_label.text = "REVOLVER"
				toy_revolver_stats_label.text = " LV: 1
 AT: 0"
		else:
			toy_revolver_label.text = "?"
		
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
		GlobalVariables.wp_lv_enable = 1

func _on_area_exited(_area: Area2D) -> void:
	GlobalVariables.wp_lv_enable = 0
	interact = false
