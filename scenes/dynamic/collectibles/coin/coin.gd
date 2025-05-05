extends Area2D

# Reference to the animated sprite for spinning
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# Reference to the audio player for the pickup sound
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node is added to the scene tree
func _ready() -> void:
	# Connect the area_entered signal to detect player collision
	body_entered.connect(_on_body_entered)
	# Ensure the animation plays
	animated_sprite.play("spin")
	print("Coin ready at position: ", position) # Debug: Confirm coin is loaded

# Called when a body enters the Area2D
func _on_body_entered(body: Node) -> void:
	print("Body entered coin: ", body.name) # Debug: Confirm collision
	# Check if the body is the player (MainPlayer2)
	if body.is_in_group("player"):
		print("Player detected, adding coin") # Debug: Confirm player detection
		# Play the pickup sound
		audio_player.play()
		# Add 1 coin to the global counter
		GameState.add_coins(1)
		# Hide the coin to prevent re-collection while sound plays
		hide()
		# Wait for the sound to finish before freeing
		await audio_player.finished
		# Remove the coin from the scene
		queue_free()
