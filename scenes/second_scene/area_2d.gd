extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var _current_balloon: Node = null

func _ready() -> void:
	pass
	# connect with Callable() instead of a raw String
	#connect("body_entered", Callable(self, "_on_body_entered"))
	#connect("body_exited",  Callable(self, "_on_body_exited"))
	

func _on_body_exited(body: Node) -> void:
	if body.name == "MainPlayer" and _current_balloon:
		# free when the player leaves
		if is_instance_valid(_current_balloon):
			_current_balloon.queue_free()
		_current_balloon = null
		print("Dialogue closed:", dialogue_start)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "MainPlayer":
		# clear any existing balloon
		if _current_balloon and is_instance_valid(_current_balloon):
			_current_balloon.queue_free()
		# show the new one
		_current_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
		print("Dialogue shown:", dialogue_start)
