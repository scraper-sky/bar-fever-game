extends Area2D

var dialogue = preload("res://dialogue/derealization.dialogue")

func _ready():
	connect("body_entered", _on_body_entered)  # Manual connection

func _on_body_entered(body):
	if body.name == "MainPlayer":
		DialogueManager.show_dialogue_balloon(dialogue, "start")
		queue_free()  # One-time trigger
