extends Node2D

@onready var spawner = $MemorySpawner
@onready var static_rect = $GlitchOverlay/StaticRect
@onready var transition_node = $TransitionLayer/TransitionRect
@onready var transition_layer = $TransitionLayer
@onready var hud_label = $Hud/InteractionHint

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
	if transition_node and transition_layer:
		# Ensure TransitionLayer is visible for fade-in
		transition_layer.visible = true
		start_fade_in()
	if hud_label:
		hud_label.visible = false

func start_fade_in() -> void:
	var shader_material = transition_node.material as ShaderMaterial
	if not shader_material:
		print("No shader material on transition node!")
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(shader_material, "shader_parameter/pixel_size", 4.0, 1.0)  # Shrink pixels
	tween.parallel().tween_property(shader_material, "shader_parameter/fade", 0.0, 0.8)  # Fade in
	tween.tween_callback(func(): print("Fade-in complete"))
	await tween.finished
	
	# Hide the TransitionLayer after fade-in
	transition_layer.visible = false
		
func _process(_delta):
	# Random static intensity with bursts
	var intensity = randf_range(0.1, 0.4)
	if randf() < 0.05:  # 5% chance per frame
		intensity = randf_range(0.6, 1.0)  # High-intensity burst
	static_rect.material.set_shader_parameter("intensity", intensity)
