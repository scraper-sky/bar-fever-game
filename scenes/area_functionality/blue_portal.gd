extends Area2D

@export var target_scene: String = "res://scenes/levels/level_2.tscn"
var fade: ColorRect
var is_transitioning = false
var fade_alpha = 0.0
var fade_duration = 0.5
var fade_timer = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("flicker")  
	fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	var screen_size = get_viewport().get_visible_rect().size
	fade.set_size(screen_size)
	fade.position = -screen_size / 2
	get_tree().root.call_deferred("add_child", fade)  

func _process(delta):
	if is_transitioning:
		fade_timer += delta
		fade_alpha = clamp(fade_timer / fade_duration, 0.0, 1.0)
		fade.color.a = fade_alpha
		if fade_timer >= fade_duration:
			is_transitioning = false
			if is_instance_valid(fade):
				fade.call_deferred("queue_free")
			get_tree().call_deferred("change_scene_to_file", target_scene)

func _on_body_entered(body):
	if body.name == "MainPlayer" and not is_transitioning:
		is_transitioning = true
		fade_timer = 0.0  # Reset timer

		
