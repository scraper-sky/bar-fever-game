extends Node2D

@onready var lock_body: Area2D = $LockBody
@onready var digit1: Sprite2D = $Digit1
@onready var digit2: Sprite2D = $Digit2
@onready var digit3: Sprite2D = $Digit3
@onready var digit4: Sprite2D = $Digit4
@onready var interact_label: Label = $InteractLabel

# Array of digit textures (0-9)
var digit_textures: Array[Texture2D] = []
# Current values of each digit (0-9)
var digit_values: Array[int] = [0, 0, 0, 0]
# Correct code
const CORRECT_CODE: Array[int] = [3, 1, 4, 2]
# Target scene to teleport to
const TARGET_SCENE_PATH: String = "res://scenes/embedded_levels/embeddedworld_12.tscn"

var can_interact: bool = false
var is_active: bool = false

func _ready() -> void:
	# Load digit textures
	for i in range(10):
		var texture_path: String = "res://assets/digits/digit_%d.png" % i
		digit_textures.append(load(texture_path) as Texture2D)
	
	# Set initial digit textures
	update_digit_display()
	
	# Connect signals for interaction
	lock_body.body_entered.connect(_on_body_entered)
	lock_body.body_exited.connect(_on_body_exited)

func _input(event: InputEvent) -> void:
	# Activate/deactivate puzzle with E key
	if event.is_action_pressed("interact") and can_interact:
		is_active = true
		interact_label.hide()
	
	# Handle digit clicks when puzzle is active
	if is_active and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos: Vector2 = get_global_mouse_position()
		if digit1.get_rect().has_point(digit1.to_local(mouse_pos)):
			increment_digit(0)
		elif digit2.get_rect().has_point(digit2.to_local(mouse_pos)):
			increment_digit(1)
		elif digit3.get_rect().has_point(digit3.to_local(mouse_pos)):
			increment_digit(2)
		elif digit4.get_rect().has_point(digit4.to_local(mouse_pos)):
			increment_digit(3)

func _on_body_entered(body: Node) -> void:
	if body.name == "MainPlayer":
		can_interact = true
		interact_label.show()

func _on_body_exited(body: Node) -> void:
	if body.name == "MainPlayer":
		can_interact = false
		interact_label.hide()
		is_active = false

func increment_digit(digit_index: int) -> void:
	# Increment the digit value (0-9, wrap around)
	digit_values[digit_index] = (digit_values[digit_index] + 1) % 10
	update_digit_display()
	
	# Check if the code is correct
	if digit_values == CORRECT_CODE:
		print("Code correct! Teleporting to: ", TARGET_SCENE_PATH)
		call_deferred("_change_scene")

func update_digit_display() -> void:
	# Update the sprite textures based on current digit values
	digit1.texture = digit_textures[digit_values[0]]
	digit2.texture = digit_textures[digit_values[1]]
	digit3.texture = digit_textures[digit_values[2]]
	digit4.texture = digit_textures[digit_values[3]]

func _change_scene() -> void:
	get_tree().change_scene_to_file(TARGET_SCENE_PATH)
