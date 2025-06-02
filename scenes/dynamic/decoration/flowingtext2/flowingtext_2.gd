extends Node2D

@export var stream_width: float = 200.0  # Width of the text stream
@export var stream_height: float = 400.0  # Height of the text stream
@export var text_speed: float = 50.0  # Speed of text movement (pixels per second)
@export var spawn_interval: float = 0.3  # Time between spawning new text lines (seconds)
@export var text_color: Color = Color(1, 0.4, 1)  # White color
@export var font_size: int = 16

var text_phrase: String = "Space_Sam:Level_19 failed to load; recalibrating_to: new_world"
var current_time: float = 0.0
var font = preload("res://fonts&style/Perfect DOS VGA 437.ttf")  # Preload the font

func _ready():
	# Start spawning text
	spawn_text()

func _process(delta):
	# Update positions of all child labels (text lines)
	for child in get_children():
		if child is Label:
			child.position.y += text_speed * delta
			# Fade out as it nears the bottom
			var t = clamp(child.position.y / stream_height, 0.0, 1.0)
			child.modulate = Color(1, 1, 1, 1.0 - t)  # Use white with fading
			# Remove if it exits the bottom
			if child.position.y > stream_height:
				child.queue_free()
	
	# Spawn new text at intervals
	current_time += delta
	if current_time >= spawn_interval:
		spawn_text()
		current_time = 0.0

func spawn_text():
	var label = Label.new()
	label.text = text_phrase
	label.position = Vector2(0, 0)  # Start at the top of the stream
	# Apply the font
	var dynamic_font = FontFile.new()
	dynamic_font.font_data = font
	label.add_theme_font_override("font", dynamic_font)
	# Apply color and other properties
	label.add_theme_color_override("font_color", text_color)  # White
	label.add_theme_font_size_override("font_size", font_size)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size = Vector2(stream_width, 20)  # Set width to stream width
	add_child(label)
