extends Area2D

# Reference to the sprite for visuals
@onready var sprite: Sprite2D = $Sprite2D
# Reference to the popup panel
@onready var popup: PopupPanel = $PopupPanel
# Reference to the error sound player
@onready var error_sound: AudioStreamPlayer2D = $ErrorSound
# Reference to the purchase sound player
@onready var purchase_sound: AudioStreamPlayer2D = $PurchaseSound

# Costs for each purchase option
const SPEED_BOOST_COST: int = 20
const MAP_HINT_COST: int = 30
const LEVEL_SKIPPER_COST: int = 130

# Called when the node is added to the scene tree
func _ready() -> void:
	# Ensure popup is hidden and not initialized as visible
	popup.hide()  # Explicitly hide on load
	popup.visible = false  # Double-check visibility state
	# Set retro size
	popup.size = Vector2(220, 140)
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
		# Show and center the popup only when player enters
		popup.popup_centered()

# Called when a body exits the Area2D
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		# Hide the popup when player leaves
		popup.hide()
		popup.visible = false  # Ensure it stays hidden

# Called when the Speed Boost button is pressed
func _on_speed_boost_pressed() -> void:
	if GameState.deduct_coins(SPEED_BOOST_COST):
		var player = get_tree().get_first_node_in_group("player")
		if player and player.has_method("apply_speed_boost"):
			player.apply_speed_boost(1.3)
			purchase_sound.play()
		popup.hide()
		popup.visible = false
	else:
		error_sound.play()

# Called when the Map Hint button is pressed
func _on_map_hint_pressed() -> void:
	if GameState.deduct_coins(MAP_HINT_COST):
		print("Map Hint purchased!")
		purchase_sound.play()
		popup.hide()
		popup.visible = false
	else:
		error_sound.play()

# Called when the Level Skipper button is pressed
func _on_level_skipper_pressed() -> void:
	if GameState.deduct_coins(LEVEL_SKIPPER_COST):
		print("Level Skipped!")
		purchase_sound.play()
		popup.hide()
		popup.visible = false
	else:
		error_sound.play()
