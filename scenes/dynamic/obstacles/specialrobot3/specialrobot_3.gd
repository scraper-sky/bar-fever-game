extends CharacterBody2D

var speed = 100.0
var direction = Vector2.RIGHT
var dialogue = preload("res://dialogue/specialrobot3.dialogue")
var _current_balloon: Node = null

func _ready() -> void:
	$Sprite2D.play("floating")
	
func _on_body_entered(body):
	if body.name == "MainPlayer":
		if _current_balloon and is_instance_valid(_current_balloon):
			_current_balloon.queue_free()
			_current_balloon = null
		_current_balloon = DialogueManager.show_dialogue_balloon(dialogue, "start")
		print("MainPlayer hit NPC Robot, dialogue triggered: start")

func _on_body_exited(body):
	if body.name == "MainPlayer":
		if _current_balloon and is_instance_valid(_current_balloon):
			_current_balloon.queue_free()
			_current_balloon = null
			print("MainPlayer exited NPC Robot, dialogue balloon freed")
	
