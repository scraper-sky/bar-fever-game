extends CharacterBody2D

var speed = 100.0
var direction = Vector2.RIGHT
var dialogue = preload("res://dialogue/specialrobot3.dialogue")

func _ready() -> void:
	$Sprite2D.play("floating")
	
func _on_body_entered(body):
	if body.name == "MainPlayer":
		print("MainPlayer hit NPC Robot")
		DialogueManager.show_dialogue_balloon(dialogue, "start")
	
