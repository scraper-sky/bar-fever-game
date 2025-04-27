extends Node

func to_level_1() -> void:
	get_tree().change_scene_to_file("res://scenes/scene_transitions/world_3_transition.tscn")

func to_world_end_4() -> void:
	get_tree().change_scene_to_file("res://scenes/fifth_scene/world_end_4.tscn")
