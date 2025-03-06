extends Area2D

@export var target_scene: String = "res://scenes/levels/level_2.tscn"
@onready var sprite = $Sprite2D  # Switch to Sprite2D for simplicity
@onready var collision = $CollisionShape2D

func _ready():
	body_entered.connect(_on_body_entered)
	if sprite:
		sprite.visible = false  # Direct hide
	if collision:
		collision.disabled = true
	visible = false  # Direct hide
	print("FivePortal init - Visible:", visible, "Sprite:", sprite.visible if sprite else "N/A")

func _on_body_entered(body):
	if body.name == "MainPlayer" and visible:
		call_deferred("transition_to_next_level")

func transition_to_next_level():
	queue_free()
	get_tree().change_scene_to_file(target_scene)

func show_portal():
	visible = true
	if sprite:
		sprite.visible = true
	if collision:
		call_deferred("set_collision_enabled", true)
	print("Show portal - Visible:", visible, "Sprite:", sprite.visible if sprite else "N/A")

func hide_portal():
	visible = false
	if sprite:
		sprite.visible = false
	if collision:
		call_deferred("set_collision_enabled", false)
	print("Hide portal - Visible:", visible, "Sprite:", sprite.visible if sprite else "N/A")

func set_collision_enabled(enabled: bool):
	collision.disabled = !enabled
