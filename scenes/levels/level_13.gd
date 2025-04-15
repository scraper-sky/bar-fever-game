extends Node2D

@onready var parallax_layer = $ParallaxBackground/ParallaxLayer
@onready var parallax_layer_2 = $ParallaxBackground/ParallaxLayer2
@onready var player = $MainPlayer2

func _process(_delta):
	parallax_layer.motion_offset.x = -player.position.x * 0.5
	parallax_layer_2.motion_offset.x = -player.position.x * 0.1
