extends Control

func _on_undream_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fifth_scene/world_end_3.tscn")
	print("undream pressed")
func _on_resume_pressed() -> void:
	pass 
