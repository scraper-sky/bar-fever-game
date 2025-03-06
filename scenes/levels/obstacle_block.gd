extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	if not sprite:
		print("Error: Sprite2D not found in ObstacleBlock!")
	if not collision:
		print("Error: CollisionShape2D not found in ObstacleBlock!")
	sprite.visible = true
	collision.disabled = false
	visible = true
	print("ObstacleBlock init - Visible:", visible, "Sprite:", sprite.visible if sprite else "N/A", "Collision:", !collision.disabled if collision else "N/A")

func show_block():
	visible = true
	if sprite:
		sprite.visible = true
	if collision:
		call_deferred("set_collision_enabled", true)
	print("Show block - Visible:", visible, "Sprite:", sprite.visible if sprite else "N/A", "Collision:", !collision.disabled if collision else "N/A")

func hide_block():
	visible = false
	if sprite:
		sprite.visible = false
	if collision:
		call_deferred("set_collision_enabled", false)
	print("Hide block - Visible:", visible, "Sprite:", sprite.visible if sprite else "N/A", "Collision:", !collision.disabled if collision else "N/A")

func set_collision_enabled(enabled: bool):
	collision.disabled = !enabled
