extends Node

var current_scene_path: String = "res://scenes/levels/level_1.tscn"  # Default to Level 1
var is_game_paused: bool = false
var player_position: Vector2 = Vector2.ZERO  # Store player position before switching

func _ready():
	is_game_paused = false
	get_tree().paused = false
	await get_tree().process_frame
	if get_tree().current_scene:
		current_scene_path = get_tree().current_scene.scene_file_path
		print("GameManager: Initialized current_scene_path to ", current_scene_path)
	else:
		print("GameManager: Warning: current_scene is null at startup")
		print("GameManager: Loading default scene: ", current_scene_path)
		get_tree().change_scene_to_file(current_scene_path)
		await get_tree().create_timer(0.1).timeout  # Wait for scene to load

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print("GameManager: Escape pressed")
		var current_scene = get_tree().current_scene
		if current_scene:
			print("GameManager: Current scene path: ", current_scene.scene_file_path)
			if current_scene.scene_file_path != "res://scenes/main_menu.tscn":
				current_scene_path = current_scene.scene_file_path
				print("Switching to menu from: ", current_scene_path)
				var player = get_tree().get_first_node_in_group("player")
				if player:
					player_position = player.position
					print("GameManager: Stored player position: ", player_position)
				else:
					print("GameManager: Player not found when storing position")
				is_game_paused = true
				get_tree().paused = true
				if current_scene.has_method("toggle_player_visibility"):
					current_scene.toggle_player_visibility(false)
				else:
					print("GameManager: Current scene does not have toggle_player_visibility method")
				await get_tree().create_timer(0.01).timeout
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			elif current_scene.scene_file_path == "res://scenes/main_menu.tscn":
				print("Escape in menu, returning to: ", current_scene_path)
				var menu = current_scene
				if menu.has_method("_on_continue_pressed"):
					menu._on_continue_pressed()
		else:
			print("GameManager: Warning: current_scene is null, cannot handle Escape")
			# Attempt to recover by loading the last known scene
			if current_scene_path:
				print("GameManager: Attempting to recover by loading: ", current_scene_path)
				get_tree().change_scene_to_file(current_scene_path)
				await get_tree().create_timer(0.1).timeout
				# Retry the Escape action after recovery
				if get_tree().current_scene and get_tree().current_scene.scene_file_path != "res://scenes/main_menu.tscn":
					print("GameManager: Recovered, retrying scene switch to menu")
					current_scene_path = get_tree().current_scene.scene_file_path
					get_tree().paused = true
					if get_tree().current_scene.has_method("toggle_player_visibility"):
						get_tree().current_scene.toggle_player_visibility(false)
					await get_tree().create_timer(0.01).timeout
					get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
