extends Area2D

# Reference to the sprite for visuals
@onready var sprite: Sprite2D = $Sprite2D
# Reference to the popup panel
@onready var popup: PopupPanel = $PopupPanel
# Reference to the error sound player
@onready var error_sound: AudioStreamPlayer2D = $ErrorSound

# Costs for each purchase option
const SPEED_BOOST_COST: int = 10
const MAP_HINT_COST: int = 15
const LEVEL_SKIPPER_COST: int = 25

# Called when the node is added to the scene tree
func _ready() -> void:
	# Connect signals for player interaction
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Connect popup buttons
	$PopupPanel/VBoxContainer/SpeedBoostButton.pressed.connect(_on_speed_boost_pressed)
	$PopupPanel/VBoxContainer/MapHintButton.pressed.connect(_on_map_hint_pressed)
	$PopupPanel/VBoxContainer/LevelSkipperButton.pressed.connect(_on_level_skipper_pressed)

# Called when a body enters the Area2D
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# Show the popup panel
		popup.popup_centered()

# Called when a body exits the Area2D
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		# Hide the popup panel
		popup.hide()

# Called when the Speed Boost button is pressed
func _on_speed_boost_pressed() -> void:
	if GameState.deduct_coins(SPEED_BOOST_COST):
		var player = get_tree().get_first_node_in_group("player")
		if player and player.has_method("apply_speed_boost"):
			player.apply_speed_boost(1.5)
		popup.hide()
	else:
		error_sound.play()

# Called when the Map Hint button is pressed
func _on_map_hint_pressed() -> void:
	if GameState.deduct_coins(MAP_HINT_COST):
		# Placeholder: Implement map hint logic (e.g., show minimap)
		print("Map Hint purchased!")
		popup.hide()
	else:
		error_sound.play()

# Called when the Level Skipper button is pressed
func _on_level_skipper_pressed() -> void:
	if GameState.deduct_coins(LEVEL_SKIPPER_COST):
		# Placeholder: Implement level skip logic
		print("Level Skipped!")
		popup.hide()
	else:
		error_sound.play()
