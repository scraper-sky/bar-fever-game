extends Node2D

var laser_cooldown: float = 3.0  
var laser_timer: float = 0.0  
var laser_scene = preload("res://scenes/dynamic/obstacles/lasers/laser.tscn")
@export var direction: float = 1.0  

func _physics_process(delta: float):
	laser_timer += delta
	if laser_timer >= laser_cooldown:
		shoot_laser()
		laser_timer = 0.0

func shoot_laser():
	var laser = laser_scene.instantiate()
	laser.position = position  
	laser.direction = direction
	get_parent().add_child(laser)
