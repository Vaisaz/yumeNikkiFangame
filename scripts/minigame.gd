extends Node2D

@onready var score_label = $ScoreLabel
@onready var wake_up_label = $WakeUp
@onready var wake_up_label_2 = $WakeUp2
var ready_to_wake_up: bool = false

var random = RandomNumberGenerator.new()

func _ready():
	GlobalVariables.cake_falling = true
	GlobalVariables.cake_score = 0

func _process(_delta):
	
	score_label.text = "SCORE: %d" % GlobalVariables.cake_score
	
	if GlobalVariables.cake_falling == true:
		GlobalVariables.cake_falling = false
		randomize()
		var cake = preload("res://scenes/cake.tscn").instantiate()
		cake.position.y = -125
		cake.position.x = randf_range(-84, 84)
		add_child(cake)
		
	if GlobalVariables.cake_score >= 10:
		wake_up_label.visible = true
		wake_up_label_2.visible = true
		ready_to_wake_up = true
		wake_up_label.scale = Vector2(random.randf_range(0.85, 1), random.randf_range(0.85, 1))
		wake_up_label_2.scale = Vector2(random.randf_range(0.85, 1), random.randf_range(0.85, 1))
		set_process(false)
		await get_tree().create_timer(0.075).timeout
		set_process(true)
		
func _input(event):
	if event.is_action_pressed("ui_cancel") and Input.is_action_just_pressed("ui_cancel"):
		GlobalVariables.player_position = Vector2(15, -46)
		get_tree().change_scene_to_file("res://scenes/locations/room.tscn")
	
	if event.is_action_pressed("wake_up") and Input.is_action_just_pressed("wake_up") and ready_to_wake_up:
		print("waking up")
		ready_to_wake_up = false
		get_tree().change_scene_to_file("res://scenes/locations/circus_outside.tscn")
