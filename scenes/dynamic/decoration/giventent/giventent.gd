extends Node2D

@export var choice = 1
func _ready() -> void:
	if choice == 2:
		$AnimatedSprite2D.play("cycle3")
	if choice == 1:
		$AnimatedSprite2D.play("cycle") 
	if choice == 0:
		$AnimatedSprite2D.play("cycle2") 
