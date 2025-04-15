extends Area2D

@onready var redportal = $AnimatedSprite2D
@export var target_position: Vector2 = Vector2(0, 0)  # Target position within the map

func _ready():
	body_entered.connect(_on_body_entered)
	redportal.play("flicker")

func _on_body_entered(body):
	if body.name == "MainPlayer" or body.name == "MainPlayer2":
		call_deferred("teleport_player", body)

func teleport_player(body):
	body.position = target_position
