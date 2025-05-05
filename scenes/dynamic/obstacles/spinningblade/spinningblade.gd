extends Node2D

@export var rotation_speed: float = -3  # radians/sec, slower clockwise
@export var fixed_position: Vector2 = Vector2(0, 0)  # Center, top edge at y=210
@export var initial_rotation: float = -3.14159  # ~1.5 rotations before spike at top

var initial_angle: float = 0.0

func _ready():
	global_position = fixed_position
	$Platform.position = Vector2.ZERO
	$Obstacles.position = Vector2.ZERO
	$Platform/Visual.centered = true
	$Platform/Visual.scale = Vector2(3.90625, 3.90625)  # Radius 500

	initial_angle = initial_rotation
	rotation = initial_angle  # Reset to safe angle

func _physics_process(delta: float):
	rotate(rotation_speed * delta)
	$Platform/Visual.modulate.a = 0.6 + 0.2 * sin(Time.get_ticks_msec() * 0.001)
