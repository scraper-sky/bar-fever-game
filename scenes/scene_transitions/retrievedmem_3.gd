extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D2.play("memorycycle")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_19.tscn")
