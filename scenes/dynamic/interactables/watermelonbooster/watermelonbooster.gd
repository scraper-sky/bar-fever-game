extends Area2D

# Reference to the animated sprite for spinning
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# Reference to the audio player for the pickup sound
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var collected: bool = false
var original_position: Vector2
var time: float = 0.0
# Bounce parameters
const BOUNCE_AMPLITUDE: float = 80.0  # Doubled from 40.0 for extreme bounce
const BOUNCE_SPEED: float = 2.0

# Called when the node enters the scene tree
func _enter_tree():
	set_process(true)
	original_position = global_position
	print("Watermelon entering at global: ", original_position)

# Called when the node is added to the scene tree
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	animated_sprite.play("spin")
	print("Watermelon ready at: ", global_position)

# Called every frame
func _process(delta: float) -> void:
	if not collected:
		time += delta * BOUNCE_SPEED
		var new_y = original_position.y + sin(time) * BOUNCE_AMPLITUDE
		global_position = Vector2(global_position.x, new_y)
		animated_sprite.position.y = -sin(time) * BOUNCE_AMPLITUDE / 2

# Called when a body enters the Area2D
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and not collected:
		collected = true
		print("Player hit watermelon, disappearing")
		# Play the pickup sound
		audio_player.play()
		# Hide immediately
		hide()
		# Wait for the sound to finish, then remove
		await audio_player.finished
		print("Watermelon removed from scene")
		queue_free()
