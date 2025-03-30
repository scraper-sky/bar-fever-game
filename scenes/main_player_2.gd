extends CharacterBody2D

@export var speed = 10.0
@export var jump_power = 15.0
@onready var animation = $AnimatedSprite2D

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
var start_position: Vector2
var is_respawning = false

# Enum to track Raina's state
enum State { RELOADING, UPGRADED }
var current_state = State.RELOADING  # Start with reloading animation

func _ready():
	start_position = position
	is_respawning = false
	update_appearance()  # Set initial appearance

func _input(event):
	if event.is_action_pressed("menu_in"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func respawn():
	if not is_respawning:
		is_respawning = true
		position = start_position
		velocity = Vector2.ZERO
		update_appearance()
		print("Respawning player at ", position)
		await get_tree().create_timer(0.1).timeout
		is_respawning = false

func update_appearance():
	if current_state == State.RELOADING:
		animation.play("reloading")
	else:  # UPGRADED
		animation.play("idle")

func upgrade():
	current_state = State.UPGRADED
	update_appearance()

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
			animation.flip_h = true
		else:
			animation.flip_h = false
		if current_state == State.RELOADING:
			if animation.animation != "reloading":
				animation.play("reloading")
		else:  # UPGRADED
			if animation.animation != "walking":
				animation.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
		if is_on_floor():
			if current_state == State.RELOADING:
				if animation.animation != "reloading":
					animation.play("reloading")
			else:  # UPGRADED
				if animation.animation != "idle":
					animation.play("idle")

	move_and_slide()

	if not is_on_floor() and direction == 0:
		if current_state == State.RELOADING:
			if animation.animation != "reloading":
				animation.play("reloading")
		else:  # UPGRADED
			if animation.animation != "idle":
				animation.play("idle")
