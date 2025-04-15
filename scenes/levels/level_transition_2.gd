extends Node2D

@onready var player = $MainPlayer2

func _ready():
	player.velocity.y = -50  # Walk upward
	print("Entered transition 2 corridor")

func _process(_delta):
	# Check player's x position for state transition
	if player.position.x >= 512:
		if player.current_state != player.State.UPGRADED:
			player.upgrade()
			GlobalGameState.has_completed_transition_2 = true  # Set the flag
