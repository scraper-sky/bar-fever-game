extends Control


func _on_undream_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_transition_2.tscn")
	#placeholder

func _on_exit_pressed() -> void:
	self.hide()
