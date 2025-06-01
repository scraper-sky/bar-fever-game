extends Area2D

@export var start_y_position: float = 0.0  # Y-position to start and loop back to
@export var speed: float = 100.0  # Speed of movement (pixels per second)
@export var direction: int = -1  # -1 for up, 1 for down
@export var cloud_scale: Vector2 = Vector2(1, 1)  # Scale of the cloud, adjustable per instance
@export var z_order: int = 0  # Z-index to control rendering order (higher renders on top)
@onready var sprite = $Sprite
@onready var collision_shape = $CollisionShape
var screen_height: float

func _ready():
	position.y = start_y_position
	screen_height = get_viewport_rect().size.y
	sprite.modulate = Color(1, 1, 1, 0.5)  # Ensure semi-transparency
	sprite.scale = cloud_scale  # Apply the exported scale
	z_index = z_order  # Set the Z-index for rendering order
	# Adjust collision shape to match sprite scale
	var shape = collision_shape.shape as RectangleShape2D
	if shape:
		shape.extents = Vector2(32, 16) * cloud_scale  # Base size (64x32 sprite) scaled

func _process(delta):
	# Move the cloud in the current direction
	position.y += speed * direction * delta
	
	# Check if the cloud exits the screen (adjusted for scale)
	var sprite_height = sprite.get_rect().size.y * sprite.scale.y
	if direction == -1 and position.y < -sprite_height:  # Exits top
		position.y = start_y_position
		direction = 1  # Start moving down
	elif direction == 1 and position.y > screen_height + sprite_height:  # Exits bottom
		position.y = start_y_position
		direction = -1  # Start moving up
