extends Node

# Global state for managing player coins
var coins: int = 0

# Signal emitted when coins change, used by HUD to update
signal coins_changed(new_amount: int)

# Called when the node is added to the scene tree
func _ready() -> void:
	# Ensure initial coin count is emitted
	emit_signal("coins_changed", coins)

# Add coins and notify listeners
func add_coins(amount: int) -> void:
	coins += amount
	emit_signal("coins_changed", coins)
	# Save the new coin count (stub for now)
	save_game()

# Deduct coins if the player has enough, return success
func deduct_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		emit_signal("coins_changed", coins)
		save_game()
		return true
	return false

# Stub for saving the game state
func save_game() -> void:
	# Placeholder: Implement saving to a file (e.g., JSON or Resource)
	pass

# Stub for loading the game state
func load_game() -> void:
	# Placeholder: Implement loading from a file
	pass
