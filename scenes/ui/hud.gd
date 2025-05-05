extends CanvasLayer

# Reference to the coin counter label
@onready var coin_label: Label = $CoinLabel

# Called when the node is added to the scene tree
func _ready() -> void:
	# Connect to GameState's coins_changed signal
	var connection_result = GameState.coins_changed.connect(_on_coins_changed)
	if connection_result == OK:
		print("HUD ready, connected to GameState coins_changed") # Debug: Confirm connection
	else:
		print("HUD ready, failed to connect to GameState coins_changed, error: ", connection_result) # Debug: Connection failure
	# Update initial coin count
	_on_coins_changed(GameState.coins)

# Update the coin counter label
func _on_coins_changed(amount: int) -> void:
	print("Coins changed, updating label to: ", amount) # Debug: Confirm signal received
	coin_label.text = "Coins: %d" % amount
