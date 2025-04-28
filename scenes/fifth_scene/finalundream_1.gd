extends Control

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_undream_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fifth_scene/world_end_5.tscn")
