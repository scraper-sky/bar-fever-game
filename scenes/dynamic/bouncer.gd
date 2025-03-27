extends Area2D

@export var jump_boost: float = 1.5  # Scales jump_power
@onready var sprite = $SpringSprite

func _ready():
	sprite.frame = 0
	sprite.stop()
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "MainPlayer":
		body.force_jump(jump_boost)  # Call player’s method
		sprite.play("extend")
		print("Bouncer triggered jump")
		await get_tree().create_timer(0.4).timeout
		sprite.play("extend", -1)
		await get_tree().create_timer(0.4).timeout
		sprite.stop()
		sprite.frame = 0
