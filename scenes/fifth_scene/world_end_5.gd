extends Node2D

@onready var animation1 = $firstanimation
@onready var animation2 = $secondanimation
@onready var animation3 = $thirdanimation

func _ready() -> void:
	animation1.play("default")
	animation2.play("default")
	animation3.play("default")
