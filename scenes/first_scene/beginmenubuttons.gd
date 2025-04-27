extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/second_scene/world_2.tscn")

func _on_load_button_pressed() -> void:
	pass # Replace with function body.
