extends Area2D

@export var speed: float = 100.0  # Base speed for dancing movement
var time: float = 0.0  # For wavy motion
var start_pos: Vector2  # Initial position for oscillation

@onready var sprite = $Sprite

func _ready():
	# Random animation order
	var anim_order = randi_range(1, 4)
	sprite.play("order" + str(anim_order))
	sprite.speed_scale = randf_range(0.8, 1.2)  # Slight speed variation
	start_pos = position  # Store starting position for dancing

func _physics_process(delta):
	time += delta
	# Wavy, dancing motion using sine waves
	var offset_x = sin(time * 2.0) * 20.0  # Horizontal wave, amplitude 20
	var offset_y = cos(time * 1.5) * 15.0  # Vertical wave, amplitude 15
	position = start_pos + Vector2(offset_x, offset_y)

	# Bounce off screen edges
	if position.x < 0 or position.x > 896:
		start_pos.x = clamp(start_pos.x, 0, 896)
		position.x = start_pos.x
	if position.y < 0 or position.y > 512:
		start_pos.y = clamp(start_pos.y, 0, 512)
		position.y = start_pos.y
