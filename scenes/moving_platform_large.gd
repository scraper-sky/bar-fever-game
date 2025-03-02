extends Path2D
class_name MovingPlatform

@export var path_follow_2D: PathFollow2D
@export var speed: float = 100.0  # Movement speed in units per second
@export var loop_mode: bool = false  # True for continuous loop, False for back-and-forth
@export var pause_at_ends: float = 0.0  # Seconds to pause at start/end (for back-and-forth mode)

func _ready():
	if not path_follow_2D:
		print("Error: PathFollow2D not assigned!")
		return
	if curve.get_point_count() < 2:
		print("Error: Path2D curve needs at least 2 points!")
		return
	start_movement()

func start_movement():
	var tween = get_tree().create_tween().set_loops()
	var path_length = curve.get_baked_length()  
	var travel_time = path_length / speed 
	if loop_mode:
		tween.tween_property(path_follow_2D, "progress", path_length, travel_time).from(0.0)
		tween.tween_callback(func(): path_follow_2D.progress = 0.0)  
	else:
		tween.tween_property(path_follow_2D, "progress", path_length, travel_time).from(0.0)
		if pause_at_ends > 0:
			tween.tween_interval(pause_at_ends)  
		tween.tween_property(path_follow_2D, "progress", 0.0, travel_time)
		if pause_at_ends > 0:
			tween.tween_interval(pause_at_ends)  
	
	
