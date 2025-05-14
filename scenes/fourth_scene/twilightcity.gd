extends Node2D

@onready var parallax_layer = $ParallaxBackground/ParallaxLayer
@onready var player = $MainPlayer
@onready var portraitbutton = $Portrait/Button
@onready var undreamer = $Undreamer2
@onready var audio_listener : AudioListener2D = $AudioListener2D
var city_music_player : AudioStreamPlayer2D = null
var npc_robot_scene = preload("res://scenes/dynamic/obstacles/npcrobot/npc_robot.tscn")
var music_queue: Array[String] = [
	"res://scenes/music/Next to You.mp3",
	"res://scenes/music/Lines of Code.mp3",
	"res://scenes/music/Factory.ogg"
]
var current_track_index: int = 0

func _ready():
	undreamer.hide()
	print("Entered twilight city")
	# Spawn 10 NPC robots
	for i in 20:
		var robot = npc_robot_scene.instantiate()
		robot.position = Vector2(randf_range(-128, 1024), randf_range(-1024, 512))
		add_child(robot)
	# Ensure AudioListener2D exists
	if audio_listener == null:
		audio_listener = AudioListener2D.new()
		audio_listener.name = "AudioListener2D"
		add_child(audio_listener)
		print("Created AudioListener2D programmatically.")
		audio_listener.make_current()
	else:
		audio_listener.make_current()

	# Ensure CityMusicPlayer exists
	city_music_player = get_node_or_null("CityMusicPlayer")
	if city_music_player == null:
		city_music_player = AudioStreamPlayer2D.new()
		city_music_player.name = "CityMusicPlayer"
		city_music_player.attenuation = 0.0
		city_music_player.max_distance = 10000
		add_child(city_music_player)
		print("Created CityMusicPlayer programmatically.")

	if music_queue.is_empty():
		push_error("Music queue is empty!")
		return
	
	# Play the first track
	play_next_track()
	# Connect the finished signal to play the next track
	city_music_player.connect("finished", Callable(self, "_on_music_finished"))

func _process(_delta):
	parallax_layer.motion_offset.x = -player.position.x * 0.25

func _on_button_pressed():
	undreamer.show()

	

func play_next_track() -> void:
	if current_track_index >= music_queue.size():
		# Loop back to the first track
		current_track_index = 0
		# Or stop if you don't want to loop
		# return
	
	# Load and play the next track
	var track_path: String = music_queue[current_track_index]
	city_music_player.stream = load(track_path)
	city_music_player.play()
	current_track_index += 1

func _on_music_finished() -> void:
	# Play the next track when the current one finishes
	play_next_track()
