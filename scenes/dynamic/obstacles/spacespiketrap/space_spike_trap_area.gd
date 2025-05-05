extends Area2D

@onready var spike = $AnimatedSprite2D
var has_hit: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	spike.play("default")
	

func _on_body_entered(body):
	if body.name == "MainPlayer2":
		body.call_deferred("respawn")
	if body.name == "MainPlayer2Level18":
		has_hit = true
		print("Player hit spike: ", body.name)
		set_deferred("monitoring", false)
		get_tree().call_deferred("reload_current_scene")
