extends Control

signal dialogues_ready

@export var final_dialogue_resource : DialogueResource
@export var final_dialogue_start : String = "start"

@export var top_portrait : TextureRect
@export var portrait_neutral : Texture2D  # Set to res://characters/nbbartender1.png
var _shake_strength: float = 10.0
var _camera: Camera2D = null  # Reference to the Camera2D
var _current_balloon: Node = null

func _ready() -> void:
	# Safety checks for exported variables
	if top_portrait == null:
		push_error("top_portrait is not assigned in the Inspector!")
		return
	if portrait_neutral == null:
		push_error("portrait_neutral is not assigned in the Inspector!")
		return
	if final_dialogue_resource == null:
		push_error("final_dialogue_resource is not assigned in the Inspector!")
		return

	# Find the Camera2D
	_camera = get_node_or_null("/root/world_end_3/Camera2D")
	if _camera == null:
		push_error("Could not find Camera2D node at '/root/world_end_3/Camera2D'. Ensure it exists in the scene.")
	else:
		print("Camera2D found at '/root/world_end_3/Camera2D': ", _camera.name)

	# Start the dialogue immediately
	_show_top_portrait()
	_current_balloon = DialogueManager.show_dialogue_balloon(final_dialogue_resource, final_dialogue_start)
	dialogues_ready.emit()
	DialogueManager.dialogue_ended.connect(_hide_top_portrait_once)

func _process(delta: float) -> void:
	# Only apply shake if _camera is valid
	if _camera != null:
		_camera.offset = Vector2(
			randf_range(-_shake_strength, _shake_strength),
			randf_range(-_shake_strength, _shake_strength)
		)

func _show_top_portrait() -> void:
	top_portrait.show()
	top_portrait.texture = portrait_neutral
	var t := create_tween()
	top_portrait.modulate.a = 0.0
	t.tween_property(top_portrait, "modulate:a", 1.0, 0.25)

func _hide_top_portrait_once(res : DialogueResource) -> void:
	if res == final_dialogue_resource:
		DialogueManager.dialogue_ended.disconnect(_hide_top_portrait_once)
		var t := create_tween()
		t.tween_property(top_portrait, "modulate:a", 0.0, 0.25)
		t.tween_callback(Callable(top_portrait, "hide"))
