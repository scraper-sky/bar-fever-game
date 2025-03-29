extends Control

func _on_undream_pressed() -> void:
	self.hide()
	
func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fourth_scene/twilightcity.tscn")
