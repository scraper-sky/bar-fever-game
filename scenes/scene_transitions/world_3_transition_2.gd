extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scene_transitions/world_3_transition_3.tscn")
