extends Area2D

# Export variable to set the target scene in the editor
@export var target_scene: String = "res://scenes/levels/level_2.tscn"
var fade: ColorRect

func _ready():
	body_entered.connect(_on_body_entered)
	# Pre-create fade node
	fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	var screen_size = get_viewport().get_visible_rect().size
	fade.set_size(screen_size)
	fade.position = -screen_size / 2
	add_child(fade)  # Add to BluePortal, not root

func _on_body_entered(body):
	if body.name == "MainPlayer":
		var tween = create_tween()
		tween.tween_property(fade, "color:a", 1.0, 0.5)
		await tween.finished
		get_tree().change_scene_to_file(target_scene)

		
