extends AudioStreamPlayer2D

func _ready():
	if stream == null:
		push_error("No audio stream assigned to AudioStreamPlayer2D!")
		return

	# Remove the unsupported 'loop' property.
	# Instead, configure looping on the stream if it supports it,
	# or rely on the manual loop logic in _process.
	autoplay = false
	play()
