extends Area2D

@export var speed: float = 100.0 
@export var distance: float = 128.0  
var direction = 1 
var start_pos: Vector2

func _ready():
	start_pos = position  
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("float")
	body_entered.connect(_on_body_entered)

func _process(delta):
	position.x += speed * direction * delta
	if abs(position.x - start_pos.x) >= distance:
		direction *= -1 

func _on_body_entered(body):
	if body.name == "MainPlayer":
		print("Ghost hit player at ", position)
		body.call_deferred("respawn")
