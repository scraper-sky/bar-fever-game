extends Area2D

var is_on = false

func _ready():
	update_sprite()
	if not is_connected("body_entered", _on_body_entered):
		connect("body_entered", _on_body_entered)

func toggle():
	is_on = !is_on
	update_sprite()

func update_sprite():
	var sprite = $Sprite2D
	if sprite:
		sprite.texture = preload("res://background&art/lamp_block2.png") if is_on else preload("res://background&art/lamp_block1.png")
	else:
		print("Error: No Sprite2D on ", name)

func _on_body_entered(body):
	if body.name == "MainPlayer":
		get_parent().toggle_adjacent(position)
