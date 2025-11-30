extends AudioStreamPlayer2D

@warning_ignore("shadowed_variable_base_class")
var is_playing: bool = false

func _process(_delta):
	if GlobalVariables.in_combat:
		$".".stop()
		is_playing = false
	elif !is_playing:
		if Inventory.corruption_has_interacted:
			$".".stream = load("res://assets/audio/corrupted.wav")
		$".".play()
		is_playing = true
	
