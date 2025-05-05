extends CharacterBody2D

@onready var sprite = $Sprite
var speed: float = 50.0  # Speed of movement
var wander_radius: float = 100.0  # The maximum horizontal distance from the start position (i.e. a 200-radius range overall)
var start_position: Vector2  # Initial position to anchor the allowed wander range
var direction: float = 1.0  # Current horizontal direction (1 for right, -1 for left)
var flip_cooldown: float = 0.0  # Timer to prevent rapid direction switches

func _ready():
	start_position = position
	direction = 1.0 if randf() > 0.5 else -1.0
	sprite.play("walking")

func _physics_process(delta: float):
	# Reduce flip cooldown over time
	if flip_cooldown > 0:
		flip_cooldown -= delta

	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Set horizontal velocity based on current direction
	velocity.x = direction * speed

	# Move the character
	move_and_slide()

	# Check if we've exceeded the allowed horizontal range from start_position
	if abs(position.x - start_position.x) >= wander_radius and flip_cooldown <= 0:
		direction = -direction
		flip_cooldown = 0.2

	# Update sprite animation, horizontal flip, and ghostly fading effect
	sprite.play("walking")
	sprite.flip_h = direction < 0
	sprite.modulate.a = 0.5 + 0.5 * sin(Time.get_ticks_msec() * 0.002)
