extends Area2D

@export var target_scene_path: String = "res://scenes/embedded_levels/embeddedworld_1.tscn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "MainPlayer":
		print("Player entered portal, transitioning to: ", target_scene_path)
		call_deferred("_change_scene")

func _change_scene() -> void:
	get_tree().change_scene_to_file(target_scene_path)
