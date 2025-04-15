extends Area2D

@export var target_scene: String = "res://scenes/levels/level_4.tscn"  # Next level

func _ready():
	body_entered.connect(_on_body_entered)
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("flicker")

func _on_body_entered(body):
	if body.name == "MainPlayer" or body.name == "MainPlayer2":
		call_deferred("transition_to_next_level")

func transition_to_next_level():
	queue_free()  # Safe now—deferred
	get_tree().change_scene_to_file(target_scene)
