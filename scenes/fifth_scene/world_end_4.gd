extends Node2D

@onready var static_rect = $GlitchOverlay/StaticRect
@onready var parallax_layer = $Background/CityLayer
@onready var player = $finalplayer

func _process(_delta):
	parallax_layer.motion_offset.x = -player.position.x * 0.45
	var intensity = randf_range(0.3, 0.6)
	if randf() < 0.4:  # 5% chance per frame
		intensity = randf_range(0.6, 0.9)  # High-intensity burst
	static_rect.material.set_shader_parameter("intensity", intensity)
	parallax_layer.motion_offset.x = -player.position.x * 0.5
