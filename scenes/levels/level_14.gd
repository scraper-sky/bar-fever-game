extends Node2D

@onready var parallax_layer = $ParallaxBackground/ParallaxLayer
@onready var player = $MainPlayer2

func _process(_delta):
	parallax_layer.motion_offset.x = -player.position.x * 0.5
