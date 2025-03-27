extends CharacterBody2D

@export var speed = 10.0
@export var jump_power = 15.0
@onready var animation_player = $AnimationPlayer

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
var start_position: Vector2
var is_respawning = false

func _ready():
	start_position = position
	is_respawning = false

func _input(event):
	if event.is_action_pressed("menu_in"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func respawn():
	if not is_respawning:
		is_respawning = true
		position = start_position
		velocity = Vector2.ZERO  # Reset movement
		animation_player.stop()
		animation_player.seek(0, true)
		print("Respawning player at ", position)
		await get_tree().create_timer(0.1).timeout  # Small delay
		is_respawning = false

func _physics_process(delta: float) -> void:
	if is_respawning:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_power * jump_multiplier

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
			animation_player.stop()

	if not is_on_floor():
		animation_player.stop()

	move_and_slide()

func force_jump(boost: float):
	velocity.y = jump_power * jump_multiplier * boost  # -450 * boost
	print("Forced jump applied, velocity: ", velocity.y)
	move_and_slide()  # Apply immediately
