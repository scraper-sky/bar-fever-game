extends Node2D

@onready var canvas = $CanvasModulate
@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.get_animation("glitch").loop = true  # Set loop
	anim_player.play("glitch")
	anim_player.speed_scale = randf_range(0.8, 1.2)
	
	
	
