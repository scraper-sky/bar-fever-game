extends Area2D

# Export variable to set the target scene in the editor
@export var target_scene: String = "res://scenes/levels/level_2.tscn"

func _ready():
	# Connect the body_entered signal to detect player collision
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if the colliding body is the player
	if body.name == "MainPlayer":  # Replace with your player node's name
		get_tree().change_scene_to_file(target_scene)
