extends Area2D

@export var dialogue_key: String = ""
@export var sprite_frames: SpriteFrames
@onready var sprite = $Sprite
var dialogue_resource = preload("res://dialogue/level_10.dialogue")

var _current_balloon: Node = null 

func _ready():
	sprite.sprite_frames = sprite_frames
	sprite.play("default")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)  
	print("Dialogue resource: ", dialogue_resource)

func _on_body_entered(body):
	if body.name == "MainPlayer":
		if _current_balloon and is_instance_valid(_current_balloon):
			_current_balloon.queue_free()
			_current_balloon = null
		_current_balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_key)
		print("Talking Ghost triggered: ", dialogue_key)

func _on_body_exited(body):
	if body.name == "MainPlayer":
		if _current_balloon and is_instance_valid(_current_balloon):
			_current_balloon.queue_free()
			_current_balloon = null
			print("Talking Ghost balloon closed: ", dialogue_key)
