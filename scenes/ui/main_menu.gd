extends Control

const IS_TESTING = true

@onready var save_info_label = $MenuContainer/SaveInfoLabel
@onready var continue_button = $MenuContainer/ContinueButton
@onready var save_button = $MenuContainer/SaveButton
@onready var load_button = $MenuContainer/LoadButton
@onready var restart_button = $MenuContainer/RestartButton
@onready var quit_button = $MenuContainer/QuitButton

func _ready():
	print("MainMenu: Connecting signals...")
	# Ensure MainMenu can process input
	mouse_filter = MOUSE_FILTER_PASS
	set_process_input(true)
	connect_button_signals()
	update_save_info()
	GameManager.is_game_paused = true
	get_tree().paused = true

func connect_button_signals():
	if continue_button:
		continue_button.pressed.connect(_on_continue_button_pressed)
		print("MainMenu: Connected pressed signal for ContinueButton")
	if save_button:
		save_button.pressed.connect(_on_save_button_pressed)
		print("MainMenu: Connected pressed signal for SaveButton")
	if load_button:
		load_button.pressed.connect(_on_load_button_pressed)
		print("MainMenu: Connected pressed signal for LoadButton")
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)
		print("MainMenu: Connected pressed signal for RestartButton")
	if quit_button:
		quit_button.pressed.connect(_on_quit_button_pressed)
		print("MainMenu: Connected pressed signal for QuitButton")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("MainMenu: Mouse clicked at: ", event.position)
		# Check if the click is over a button
		if continue_button.get_rect().has_point(event.position):
			print("MainMenu: Clicked on ContinueButton")
		if save_button.get_rect().has_point(event.position):
			print("MainMenu: Clicked on SaveButton")

func _on_continue_button_pressed():
	print("Continue button pressed")
	GameManager.is_game_paused = false
	get_tree().paused = false
	get_tree().change_scene_to_file(GameManager.current_scene_path)
	print("Returned to scene: ", GameManager.current_scene_path)

func _on_save_button_pressed():
	print("Save button pressed")
	if IS_TESTING:
		print("Save skipped during testing")
		return
	var save_data = {
		"level": GameManager.current_scene_path,
		"player_x": GameManager.player_position.x,
		"player_y": GameManager.player_position.y
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Game saved to user://savegame.json")
		update_save_info()
	else:
		print("Failed to save game: Unable to open file")

func _on_load_button_pressed():
	print("Load button pressed")
	if IS_TESTING:
		print("Load skipped during testing—starting fresh")
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
		return
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		if file:
			var data = JSON.parse_string(file.get_as_text())
			file.close()
			if data and "level" in data:
				GameManager.is_game_paused = false
				get_tree().paused = false
				get_tree().change_scene_to_file(data["level"])
				await get_tree().create_timer(0.1).timeout
				var player = get_tree().get_first_node_in_group("player")
				if player:
					player.position = Vector2(data["player_x"], data["player_y"])
					print("Game loaded from user://savegame.json to", data["level"])
				else:
					print("Player not found after loading (will be set visible by LevelRoot)")
			else:
				print("Invalid save data")
		else:
			print("Failed to load game: Unable to open file")
	else:
		print("No save file found—starting fresh")
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_restart_button_pressed():
	print("Restart button pressed")
	GameManager.is_game_paused = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_quit_button_pressed():
	print("Quit button pressed")
	if not IS_TESTING:
		_on_save_button_pressed()
	get_tree().quit()

func update_save_info():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		if file:
			var text = file.get_as_text()
			file.close()
			var data = JSON.parse_string(text)
			if data and "level" in data:
				var level_name = data["level"].get_file().get_basename()
				var pos_x = data["player_x"]
				var pos_y = data["player_y"]
				save_info_label.text = "Saved: %s (%.0f, %.0f)" % [level_name, pos_x, pos_y]
			else:
				save_info_label.text = "Saved: Invalid data"
		else:
			save_info_label.text = "Saved: Error reading file"
	else:
		save_info_label.text = "Saved: None"
