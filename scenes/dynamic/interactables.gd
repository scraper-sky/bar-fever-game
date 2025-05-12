extends Area2D

@export var hint_text: String = "Press E to open"
@export var interaction_radius: float = 50.0
@onready var hud_layer = get_node("/root/" + get_tree().current_scene.name + "/Hud/InteractionHint")

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name in ["MainPlayer", "MainPlayer2", "MainPlayer2Level18"]:
		if hud_layer:
			hud_layer.text = hint_text
			hud_layer.visible = true

func _on_body_exited(body):
	if body.name in ["MainPlayer", "MainPlayer2", "MainPlayer2Level18"]:
		if hud_layer:
			hud_layer.visible = false
