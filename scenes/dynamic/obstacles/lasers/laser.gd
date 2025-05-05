extends Area2D

var speed: float = 450.0
var direction: float = 1.0
var stopped: bool = false
var has_hit: bool = false

func _ready():
	add_to_group("laser")
	print("Laser instantiated at position: ", position)

func _physics_process(delta: float):
	if stopped:
		queue_free()
		return

	position.x += direction * speed * delta

	var current_modulate = $Visual.modulate
	current_modulate.a = 0.5 + 0.5 * sin(Time.get_ticks_msec() * 0.015)
	$Visual.modulate = current_modulate

	for body in get_overlapping_bodies():
		if body.name == "MainPlayer2":
			print("Laser collided with MainPlayer2")
			body.position = Vector2(0, 0)
			break
		elif body.name == "MainPlayer2Level18":
			has_hit = true
			print("Player hit spike: ", body.name)
			set_deferred("monitoring", false)
			get_tree().call_deferred("reload_current_scene")	
		elif body is StaticBody2D:
			print("Laser hit TileMap at position: ", position)
			stopped = true
			break
