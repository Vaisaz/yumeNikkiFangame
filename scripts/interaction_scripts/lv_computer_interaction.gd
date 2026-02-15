extends Area2D

func _on_area_entered(area: Area2D) -> void:
	GlobalVariables.wp_lv_enable = 1

func _on_area_exited(area: Area2D) -> void:
	GlobalVariables.wp_lv_enable = 0
