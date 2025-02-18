extends CharacterBody2D

@export var speed = 10.0 
@export var jump_power = 15.0 
@onready var animation_player = $AnimationPlayer

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_power * jump_multiplier

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed * speed_multiplier
		if direction < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		if is_on_floor():
			animation_player.play("default")
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
		if is_on_floor():
			animation_player.stop()  # Stop animation when idle on the ground

	# Stop animation if jumping or falling
	if not is_on_floor():
		animation_player.stop()

	move_and_slide()
