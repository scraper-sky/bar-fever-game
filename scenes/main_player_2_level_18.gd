extends CharacterBody2D

@export var speed = 10.0
@export var jump_power = 15.0
@export var jump_duration: float = 0.5
@onready var animation = $AnimatedSprite2D

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
var start_position: Vector2 = Vector2(400, 200)
var is_respawning = false
var on_spinning_circle: bool = true
var is_jumping: bool = false
var jump_time: float = 0.0

enum State { RELOADING, UPGRADED }
var current_state: State

func _ready():
	start_position = Vector2(400, 200)
	position = start_position
	is_respawning = false

	var current_scene = get_tree().current_scene
	if current_scene and current_scene.name == "LevelTransition2" and not GlobalGameState.has_completed_transition_2:
		current_state = State.RELOADING
	else:
		current_state = State.UPGRADED

	print("Current scene name: ", current_scene.name if current_scene else "null")
	print("GlobalGameState.has_completed_transition_2: ", GlobalGameState.has_completed_transition_2)
	print("Initial state: ", State.keys()[current_state])
	update_appearance()

func _input(event):
	if event.is_action_pressed("menu_in"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func respawn():
	if not is_respawning:
		is_respawning = true
		position = start_position
		is_jumping = false
		jump_time = 0.0
		update_appearance()
		print("Respawning player at ", position)
		await get_tree().create_timer(0.1).timeout
		is_respawning = false

func update_appearance():
	if current_state == State.RELOADING:
		animation.play("reloading")
	else:
		animation.play("idle")
	print("Updated appearance to: ", animation.animation)

func upgrade():
	current_state = State.UPGRADED
	update_appearance()

func _physics_process(delta: float) -> void:
	if is_respawning:
		return

	if on_spinning_circle:
		position.x = start_position.x

		if Input.is_action_just_pressed("ui_accept") and not is_jumping:
			is_jumping = true
			jump_time = 0.0

		if is_jumping:
			jump_time += delta
			var t = jump_time / jump_duration
			if t >= 1.0:
				is_jumping = false
				position.y = start_position.y
			else:
				var jump_height = jump_power * jump_multiplier
				position.y = start_position.y + jump_height * (4.0 * t * (1.0 - t))
		else:
			position.y = start_position.y

		if is_jumping:
			if current_state == State.RELOADING:
				if animation.animation != "reloading":
					animation.play("reloading")
			else:
				if animation.animation != "idle":
					animation.play("idle")
		else:
			if current_state == State.RELOADING:
				if animation.animation != "reloading":
					animation.play("reloading")
			else:
				if animation.animation != "idle":
					animation.play("idle")
	else:
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
			else:
				if animation.animation != "walking":
					animation.play("walking")
		else:
			velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
			if is_on_floor():
				if current_state == State.RELOADING:
					if animation.animation != "reloading":
						animation.play("reloading")
				else:
					if animation.animation != "idle":
						animation.play("idle")

		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_power * jump_multiplier

		move_and_slide()

	var slide_count = get_slide_collision_count()
	for i in range(slide_count):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("laser"):
			print("Raina hit by laser! Respawning at ", start_position)
			respawn()
			break

	if not is_on_floor() and direction == 0 and not on_spinning_circle:
		if current_state == State.RELOADING:
			if animation.animation != "reloading":
				animation.play("reloading")
		else:
			if animation.animation != "idle":
				animation.play("idle")
