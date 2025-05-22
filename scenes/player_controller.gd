extends CharacterBody2D

@export var speed = 10.0
@export var jump_power = 15.0
@onready var animated_sprite = $AnimatedSprite
@onready var jump_sound = $JumpSound
@onready var death_sound = $DeathSound

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
var start_position: Vector2
var is_respawning = false
var base_speed: float = 300.0  # Adjusted to match original speed (10 * 30)
var current_speed: float = base_speed
var base_jump_power: float = jump_power
var current_jump_power: float = base_jump_power
var is_dead = false  # Track death state

signal booster_started(duration: float)

func _ready():
	start_position = position
	is_respawning = false
	is_dead = false
	# Set initial scale to 1.5
	animated_sprite.scale = Vector2(1.5, 1.5)

func _input(event):
	if event.is_action_pressed("menu_in"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func respawn():
	if not is_respawning:
		is_respawning = true
		# Reset visual properties to 1.5 scale
		animated_sprite.scale = Vector2(1.6, 1.6)
		animated_sprite.visible = true
		# Reset position and state
		position = start_position
		velocity = Vector2.ZERO
		animated_sprite.play("walk")
		animated_sprite.frame = 0
		animated_sprite.stop()
		current_speed = base_speed
		current_jump_power = base_jump_power
		is_dead = false
		print("Respawning player at ", position, " with scale ", animated_sprite.scale)
		await get_tree().create_timer(0.1).timeout
		is_respawning = false

func _physics_process(delta: float) -> void:
	if is_respawning or is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_power * jump_multiplier
		animated_sprite.play("jump")
		jump_sound.play()  # Play jump sound
		print("Jump velocity.y: ", velocity.y)

	direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * current_speed
		animated_sprite.flip_h = direction < 0
		if is_on_floor():
			animated_sprite.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		if is_on_floor():
			animated_sprite.play("idle")
		else:
			animated_sprite.play("jump")

	move_and_slide()

	# Detect collision with hazards
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("hazards"):
			die()

func die():
	if not is_dead:
		is_dead = true
		animated_sprite.play("death")  # Play death animation
		death_sound.play()  # Play death sound
		velocity = Vector2.ZERO  # Stop movement
		# Wait for animation to finish
		await animated_sprite.animation_finished
		animated_sprite.visible = false  # Hide sprite after animation
		# Ensure scale is reset to 1.5 before respawn
		animated_sprite.scale = Vector2(1.6, 1.6)
		respawn()  # Respawn after animation
		print("Player died and respawned with scale ", animated_sprite.scale)

func apply_speed_boost(multiplier: float) -> void:
	current_speed = base_speed * multiplier
	print("Speed boost applied, current_speed: ", current_speed)
	emit_signal("booster_started", 5.0)

func remove_speed_boost() -> void:
	current_speed = base_speed
	print("Speed boost removed, current_speed: ", current_speed)

func apply_jump_boost(multiplier: float) -> void:
	current_jump_power = base_jump_power * multiplier
	print("Jump boost applied, current_jump_power: ", current_jump_power)

func remove_jump_boost() -> void:
	current_jump_power = base_jump_power
	print("Jump boost removed, current_jump_power: ", current_jump_power)

func force_jump(boost: float):
	velocity.y = current_jump_power * jump_multiplier * boost
	animated_sprite.play("jump")
	jump_sound.play()  # Play jump sound
	animated_sprite.flip_h = direction < 0 if direction != 0 else animated_sprite.flip_h
	print("Forced jump applied, velocity.y: ", velocity.y)
	move_and_slide()
