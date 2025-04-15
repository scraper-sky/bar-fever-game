extends Area2D

@onready var spike = $AnimatedSprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	spike.play("default")
	

func _on_body_entered(body):
	if body.name == "MainPlayer2":
		body.call_deferred("respawn")
