extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
var tween: Tween = null
const BOUNCE_AMPLITUDE: float = 10.0  # Height of the bounce in pixels
const BOUNCE_DURATION: float = 1.0    # Duration of one bounce cycle in seconds

func _ready() -> void:
	start_bouncing()

func start_bouncing() -> void:
	if tween:
		tween.kill()  # Stop any existing tween
	tween = create_tween().set_loops()
	tween.tween_property(sprite, "position:y", sprite.position.y + BOUNCE_AMPLITUDE, BOUNCE_DURATION / 2.0)\
		 .set_ease(Tween.EASE_IN_OUT)\
		 .set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position:y", sprite.position.y - BOUNCE_AMPLITUDE, BOUNCE_DURATION / 2.0)\
		 .set_ease(Tween.EASE_IN_OUT)\
		 .set_trans(Tween.TRANS_SINE)
