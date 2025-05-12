extends AudioStreamPlayer2D

func _ready():
	if stream == null:
		push_error("No audio stream assigned to AudioStreamPlayer2D!")
		return

	# Disable autoplay to control when the music starts
	autoplay = false

	# Wait 5 seconds before playing
	await get_tree().create_timer(3.0).timeout
	play()
