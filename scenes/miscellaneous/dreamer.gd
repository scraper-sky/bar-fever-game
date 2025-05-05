extends Control

@export var give_up_scene: String = "res://scenes/first_scene/beginmenu.tscn"

func _ready() -> void:
	$AnimatedSprite2D.play("default")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(give_up_scene)
