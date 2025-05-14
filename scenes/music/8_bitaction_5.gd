extends AudioStreamPlayer2D

func _ready():
	if stream == null:
		push_error("No audio stream assigned to AudioStreamPlayer2D!")
		return

	# Disable autoplay to control when the music starts
	autoplay = false

	# Wait 5 seconds before playing
	await get_tree().create_timer(1.0).timeout
	play()
	# Connect the finished signal to loop the music
	connect("finished", Callable(self, "_on_finished"))

func _on_finished():
	# Restart the music when it finishes
	play()
