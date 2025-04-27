extends Node2D


@onready var static_rect = $GlitchOverlay/StaticRect

func _process(_delta):
	# Random static intensity with bursts
	var intensity = randf_range(0.1, 0.4)
	if randf() < 0.05:  # 5% chance per frame
		intensity = randf_range(0.6, 1.0)  # High-intensity burst
	static_rect.material.set_shader_parameter("intensity", intensity)

func _ready() -> void:
	$AnimatedSprite2D.play("default")
