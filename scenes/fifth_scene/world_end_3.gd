extends Node2D

@onready var static_rect = $GlitchOverlay/StaticRect

func _process(_delta):
	var intensity = randf_range(0.3, 1.0)
	if randf() < 0.4:  
		intensity = randf_range(0.6, 1.3)  
	static_rect.material.set_shader_parameter("intensity", intensity)
