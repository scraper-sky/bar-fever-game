extends Area2D

@onready var animation = $AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)
	animation.play("wave")

func _on_body_entered(body):
	if body.name == "MainPlayer2":
		body.call_deferred("respawn")
