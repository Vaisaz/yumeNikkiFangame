extends Node2D

@onready var clown = $Combat/Enemy
@onready var combat_frame = $Combat/CombatFrame
@onready var shoot = $Combat/ShootButton
@onready var enemy = $Combat/Enemy
@onready var closing_eyes = $Combat/ClosingEyes
@onready var sound = $Sound
@onready var heart_beat = $HeartBeat
@onready var clowning_around = $ClowningAround

var random = RandomNumberGenerator.new()
var death = random.randi_range(3, 6)
var n = 2

func _ready() -> void:
	for n in 130:
		clown.modulate = Color8(255, 255, 255, n*2)
		set_process(false)
		await get_tree().create_timer(0.00001).timeout
		set_process(true)
	enemy.play("shoot")
	await enemy.animation_finished
	sound.play()
	enemy.play_backwards("shoot")
	await enemy.animation_finished
	enemy.play("default")
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	##DisplayServer.cursor_set_custom_image(preload("res://assets/sprites/circus_dream/clown_combat/hand.png"))
	shoot.visible = true

func _on_shoot_button_pressed() -> void:
	shoot.visible = false
	closing_eyes.visible = true
	closing_eyes.play("default")
	heart_beat.play()
	for n in 11:
		heart_beat.volume_db = n
		clowning_around.volume_db = -n
		set_process(false)
		await get_tree().create_timer(0.1).timeout
		set_process(true)
	await closing_eyes.animation_finished
	if death == n:
		sound.stream = preload("res://assets/audio/shot.mp3")
		sound.play()
		set_process(false)
		await get_tree().create_timer(0.25).timeout
		set_process(true)
		get_tree().quit()
	sound.play()
	closing_eyes.play_backwards("default")
	await closing_eyes.animation_finished
	closing_eyes.visible = false
	for n in 11:
		heart_beat.volume_db = -n
		clowning_around.volume_db = n-10
		set_process(false)
		await get_tree().create_timer(0.1).timeout
		set_process(true)
	heart_beat.stop()
	n+=1
	enemy.play("shoot")
	await enemy.animation_finished
	if death == n:
		sound.stream = preload("res://assets/audio/shot.mp3")
		sound.play()
		set_process(false)
		await get_tree().create_timer(0.25).timeout
		set_process(true)
		get_tree().quit()
	sound.play()
	enemy.play_backwards("shoot")
	await enemy.animation_finished
	enemy.play("default")
	n+=1
	shoot.visible = true
