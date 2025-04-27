extends Node2D

@onready var static_rect = $GlitchOverlay/StaticRect
@onready var parallax_layer = $ParallaxBackground/ParallaxLayer
@onready var player = $finalplayer

func _process(_delta):
	# Random static intensity with bursts
	var intensity = randf_range(0.3, 1.0)
	if randf() < 0.4:  # 5% chance per frame
		intensity = randf_range(0.6, 1.3)  # High-intensity burst
	static_rect.material.set_shader_parameter("intensity", intensity)
	parallax_layer.motion_offset.x = -player.position.x * 0.5
	
	
