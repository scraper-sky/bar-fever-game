extends Control

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var dialogue_resource_2: DialogueResource
@export var dialogue_start_2: String = "start"


func _on_strange_paper_pressed() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)


func _on_alcohol_bottles_pressed() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource_2, dialogue_start_2)
