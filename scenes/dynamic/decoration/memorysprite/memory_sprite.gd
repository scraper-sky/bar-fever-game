extends Area2D

@export var speed: float = 200.0  # Pixels per second
var direction: Vector2

func _ready():
	# Random start direction
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	# Random memory sprite
	$Sprite.texture = load("res://assets/memories/cyber_mem_" + str(randi_range(1, 10)) + ".png")

func _physics_process(delta):
	# Move in direction
	position += direction * speed * delta
	# Bounce off screen edges
	if position.x < 0 or position.x > 896:  # Screen width (adjust to map size)
		direction.x *= -1
	if position.y < 0 or position.y > 512:  # Screen height (adjust to map size)
		direction.y *= -1
