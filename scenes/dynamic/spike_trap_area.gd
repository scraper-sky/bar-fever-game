extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "MainPlayer":
		body.call_deferred("respawn")
