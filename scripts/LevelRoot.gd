extends Node2D

func toggle_player_visibility(make_visible: bool):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Stop any running tweens on the player
		var tweens = get_tree().get_nodes_in_group("tween")
		for tween in tweens:
			if tween.is_valid() and tween.get("target") == player:
				tween.kill()
		player.visible = make_visible
		print("LevelRoot: Player visibility set to: ", make_visible)
	else:
		print("LevelRoot: Player not found")

func _ready():
	# Ensure the player is visible when the level loads
	toggle_player_visibility(true)
