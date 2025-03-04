extends Control

# Flag to disable saving during testing
const IS_TESTING = true  # Set to false for release builds

func _ready():
	$MenuContainer/ContinueButton.pressed.connect(_on_continue_pressed)
	$MenuContainer/SaveButton.pressed.connect(_on_save_pressed)
	$MenuContainer/LoadButton.pressed.connect(_on_load_pressed)
	$MenuContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_save_pressed():
	if IS_TESTING:
		print("Save skipped during testing")
		return
	var save_data = {
		"level": get_tree().current_scene.scene_file_path,
		"player_x": 0.0,
		"player_y": 0.0
	}
	var player = get_tree().get_first_node_in_group("player")
	if player:
		save_data["player_x"] = player.position.x
		save_data["player_y"] = player.position.y
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved to user://savegame.json")

func _on_load_pressed():
	if IS_TESTING:
		print("Load skipped during testing—starting fresh")
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
		return
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		get_tree().change_scene_to_file(data["level"])
		await get_tree().process_frame
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.position = Vector2(data["player_x"], data["player_y"])
			print("Game loaded from user://savegame.json to", data["level"])
	else:
		print("No save file found—starting fresh")
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_quit_pressed():
	get_tree().quit()
