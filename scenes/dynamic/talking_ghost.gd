extends Area2D

@export var dialogue_key: String = ""
@export var sprite_frames: SpriteFrames
@onready var sprite = $Sprite
var dialogue_resource = preload("res://dialogue/level_10.dialogue")

func _ready():
	sprite.sprite_frames = sprite_frames
	sprite.play("default")
	body_entered.connect(_on_body_entered)
	print("Dialogue resource: ", dialogue_resource)

func _on_body_entered(body):
	if body.name == "MainPlayer":
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_key)
		print("Talking Ghost triggered: ", dialogue_key)
