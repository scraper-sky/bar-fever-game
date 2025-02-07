extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -400.0
@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Handle movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
		if direction < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false

		# Play walk animation only if on the ground
		if is_on_floor():
			animation_player.play("default")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor():
			animation_player.stop()  # Stop animation when idle on the ground

	# Stop animation if jumping or falling
	if not is_on_floor():
		animation_player.stop()
		
	move_and_slide()
