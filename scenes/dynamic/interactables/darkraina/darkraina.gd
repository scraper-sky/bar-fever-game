extends Area2D
@export var dialogue_key: String = "start"
@export var facing_direction: int = 1  # 1 for right, -1 for left
@export var dialogue_resource = preload("res://dialogue/level1darkraina.dialogue")  # Default, adjust per level
@onready var animated_sprite = $AnimatedSprite
var _current_balloon: Node = null
var has_triggered = false

func _ready():
	animated_sprite.play("floating")
	animated_sprite.flip_h = (facing_direction == -1)  # Flip sprite based on direction
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	print("Dialogue resource: ", dialogue_resource)

func _on_body_entered(body):
	if body.name == "MainPlayer" and not has_triggered:
		has_triggered = true
		if _current_balloon and is_instance_valid(_current_balloon):
			_current_balloon.queue_free()
			_current_balloon = null
		_current_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_key)
		print("Dark Raina triggered: ", dialogue_key)
		# Wait for dialogue to end and then disappear
		if _current_balloon:
			await _current_balloon.tree_exited  # Wait for balloon to be freed
			queue_free()  # Disappear after dialogue ends

func _on_body_exited(body):
	if body.name == "MainPlayer" and has_triggered:
		if _current_balloon and is_instance_valid(_current_balloon):
			_current_balloon.queue_free()
			_current_balloon = null
			queue_free()  # Disappear immediately if exited
		print("Dark Raina balloon closed: ", dialogue_key)
