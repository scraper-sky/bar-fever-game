extends Node2D

@onready var parallax_layer = $ParallaxBackground/ParallaxLayer
@onready var parallax_layer_2 = $ParallaxBackground/ParallaxLayer2
@onready var player = $MainPlayer2
@onready var transition_node = $TransitionLayer/TransitionRect
@onready var transition_layer = $TransitionLayer

func _process(_delta):
	parallax_layer.motion_offset.x = -player.position.x * 0.5
	parallax_layer_2.motion_offset.x = -player.position.x * 0.1

func _ready():
	if transition_node and transition_layer:
		# Ensure TransitionLayer is visible for fade-in
		transition_layer.visible = true
		start_fade_in()

func start_fade_in() -> void:
	var shader_material = transition_node.material as ShaderMaterial
	if not shader_material:
		print("No shader material on transition node!")
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(shader_material, "shader_parameter/pixel_size", 4.0, 1.0)  # Shrink pixels
	tween.parallel().tween_property(shader_material, "shader_parameter/fade", 0.0, 1.0)  # Fade in
	tween.tween_callback(func(): print("Fade-in complete"))
	await tween.finished
	
	# Hide the TransitionLayer after fade-in
	transition_layer.visible = false
