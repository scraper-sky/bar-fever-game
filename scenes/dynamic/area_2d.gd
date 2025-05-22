extends Area2D

func _ready():
	$AnimatedSprite2D.play("flicker")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "MainPlayer":
		body.call_deferred("die")
	if body.name == "MainPlayer2":
		body.call_deferred("respawn")
