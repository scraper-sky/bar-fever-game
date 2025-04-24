extends Node2D

@export var dialogue_start: String = "start"
var dialogue_resource = preload("res://dialogue/curiosity.dialogue")

func _ready() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
