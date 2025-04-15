extends AudioStreamPlayer2D

func _ready():
	# Ensure the stream is assigned
	if stream == null:
		push_error("No audio stream assigned to AudioStreamPlayer2D!")
		return

	# Handle looping based on the stream type
	if stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD  # Enable looping for WAV
	else:
		# For MP3 or Ogg, we'll handle looping manually in _process
		pass

	# Disable autoplay to avoid conflicts
	autoplay = false

	# Play the audio
	play()

func _process(_delta):
	# Manually handle looping for streams that don't support it (e.g., MP3, Ogg)
	if stream and not (stream is AudioStreamWAV) and not playing:
		play()  # Restart the audio when it finishes
