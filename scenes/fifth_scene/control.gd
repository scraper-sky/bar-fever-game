extends Control

func _ready() -> void:
	$fourthanimation.play("default")

func _on_stillbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/first_scene/beginmenu.tscn")

func _on_notbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/first_scene/beginmenu.tscn")
