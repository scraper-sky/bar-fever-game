extends Node2D

@onready var parallax_layer = $ParallaxBackground/ParallaxLayer
@onready var player = $MainPlayer
var npc_robot_scene = preload("res://scenes/dynamic/npc_robot.tscn")

func _ready():
	print("Entered twilight city")
	# Spawn 10 NPC robots
	for i in 20:
		var robot = npc_robot_scene.instantiate()
		robot.position = Vector2(randf_range(-128, 1024), randf_range(-1024, 512))
		add_child(robot)

func _process(_delta):
	parallax_layer.motion_offset.x = -player.position.x * 0.25
