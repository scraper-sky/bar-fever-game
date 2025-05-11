extends Node2D

@onready var spawner = $MemorySpawner
@onready var static_rect = $GlitchOverlay/StaticRect
var memory_scene = preload("res://scenes/dynamic/decoration/memorysprite/memory_sprite.tscn")

func _ready():
	print(get_children())  # List children
	if spawner == null:
		printerr("MemorySpawner not found!")
		return
	for i in 40:
		var memory = memory_scene.instantiate()
		memory.position = Vector2(randf_range(0, 896), randf_range(0, 512))
		spawner.add_child(memory)

func _process(_delta):
	# Random static intensity with bursts
	var intensity = randf_range(0.1, 0.4)
	if randf() < 0.05:  # 5% chance per frame
		intensity = randf_range(0.6, 1.0)  # High-intensity burst
	static_rect.material.set_shader_parameter("intensity", intensity)
