extends AudioStreamPlayer2D

var is_playing: bool = false

func _process(delta):
	if GlobalVariables.in_combat:
		$".".stop()
		is_playing = false
	elif !is_playing:
		$".".play()
		is_playing = true
		
	
