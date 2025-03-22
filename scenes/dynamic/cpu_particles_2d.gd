extends CPUParticles2D

func _ready():
	emitting = true  # Ensure it starts
	# Optional: Randomize start for variety
	lifetime = randf_range(1.5, 2.5)
