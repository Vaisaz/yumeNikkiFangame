extends Node2D

@onready var score_label = $ScoreLabel

func _process(delta: float) -> void:
	
	score_label.text = "SCORE: %d" % GlobalVariables.cake_score
	
	if GlobalVariables.cake_falling == true:
		GlobalVariables.cake_falling = false
		randomize()
		var cake = preload("res://scenes/cake.tscn").instantiate()
		cake.position.y = -125
		cake.position.x = randf_range(-84, 84)
		add_child(cake)
