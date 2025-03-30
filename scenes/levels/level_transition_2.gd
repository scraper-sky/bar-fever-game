extends Node2D

@onready var player = $MainPlayer2

func _ready():
	print("Entered transition 2 corridor")
	
func _process(_delta):
	if player.position.x >= 512:
		if player.current_state != player.State.UPGRADED:
			player.upgrade()
