extends Path2D
class_name MovingPlatform

@export var path_follow_2D: PathFollow2D
@export var speed: float = 100.0
@export var loop_mode: bool = false
@export var pause_at_ends: float = 0.0

var tween: Tween
var is_moving = true

func _ready():
	if not path_follow_2D:
		print("Error: PathFollow2D not assigned!")
		return
	if curve.get_point_count() < 2:
		print("Error: Path2D curve needs at least 2 points!")
		return
	$AnimatableBody2D/Sprite2D.play("default")
	start_movement()

func start_movement():
	while is_moving:
		tween = get_tree().create_tween()
		var path_length = curve.get_baked_length()
		var travel_time = path_length / speed
		if loop_mode:
			tween.tween_property(path_follow_2D, "progress", path_length, travel_time).from(0.0)
			await tween.finished
			path_follow_2D.progress = 0.0
		else:
			tween.tween_property(path_follow_2D, "progress", path_length, travel_time).from(0.0)
			if pause_at_ends > 0:
				await get_tree().create_timer(pause_at_ends).timeout
			tween.tween_property(path_follow_2D, "progress", 0.0, travel_time)
			if pause_at_ends > 0:
				await get_tree().create_timer(pause_at_ends).timeout
		await tween.finished

func stop_tween():
	is_moving = false
	if tween and tween.is_valid():
		tween.kill()
		tween = null
