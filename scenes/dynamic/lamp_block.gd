extends Area2D

var is_on = false

func _ready():
	update_sprite()
	# Connect Area2D signal for click or overlap
	connect("input_event", _on_input_event)
	# For proximity, uncomment below and set Collision Layer/Mask
	# connect("body_entered", _on_body_entered)

func toggle():
	is_on = !is_on
	update_sprite()

func update_sprite():
	var sprite = $Sprite2D
	if sprite:
		sprite.texture = preload("res://background&art/lamp_block2.png") if is_on else preload("res://background&art/lamp_block1.png")
	else:
		print("Error: No Sprite2D on ", name)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_parent().toggle_adjacent(position)  # Call parent to toggle this and adjacent

# Optional: Proximity-based toggle
# func _on_body_entered(body):
#     if body.name == "MainPlayer":
#         get_parent().toggle_adjacent(position)
