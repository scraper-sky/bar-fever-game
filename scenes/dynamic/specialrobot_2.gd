extends CharacterBody2D

var speed = 100.0
var direction = Vector2.RIGHT
var dialogue = preload("res://dialogue/specialrobot2.dialogue")

func _ready():
	speed = randf_range(80, 120)
	direction.x = [-1, 1].pick_random()

func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()
	if position.x < 0 or position.x > 896:
		direction.x *= -1
	if randf() < 0.01:  # 1% chance per frame to change direction
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _on_body_entered(body):
	if body.name == "MainPlayer":
		print("MainPlayer hit NPC Robot")
		DialogueManager.show_dialogue_balloon(dialogue, "start")
