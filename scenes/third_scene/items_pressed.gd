class_name TwoStageDialogueController
extends Control

signal dialogues_ready

@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "start"
@export var dialogue_resource_2 : DialogueResource
@export var dialogue_start_2 : String = "start"
@export var final_dialogue_resource : DialogueResource
@export var final_dialogue_start : String = "start"

@export var top_portrait : TextureRect
@export var portrait_neutral : Texture2D  # Set to res://characters/nbbartender1.png
@export var portrait_angry : Texture2D   # Set to res://characters/nbbartender2.png

var _seen_first : bool = false
var _seen_second : bool = false
var _final_fired : bool = false
var _current_balloon: Node = null
var _last_dialogue_line: DialogueLine = null

func _ready() -> void:
	if top_portrait == null:
		push_error("top_portrait is not assigned in the Inspector!")
		return
	if portrait_neutral == null or portrait_angry == null:
		push_error("Portraits not assigned in the Inspector!")
		return
	if dialogue_resource == null or dialogue_resource_2 == null or final_dialogue_resource == null:
		push_error("One or more dialogue resources not assigned in the Inspector!")
		return
	top_portrait.hide()
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _process(_delta: float) -> void:
	if _final_fired and _current_balloon and is_instance_valid(_current_balloon):
		var current_line = _current_balloon.dialogue_line
		if current_line and current_line != _last_dialogue_line:
			_last_dialogue_line = current_line
			_update_top_portrait(current_line)

func _on_strange_paper_pressed() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_alcohol_bottles_pressed() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource_2, dialogue_start_2)

func _on_dialogue_ended(res : DialogueResource) -> void:
	if res == dialogue_resource:
		_seen_first = true
	elif res == dialogue_resource_2:
		_seen_second = true

	if _seen_first and _seen_second and not _final_fired:
		_final_fired = true
		_show_top_portrait()
		# Start the final dialogue without a custom game state
		_current_balloon = DialogueManager.show_dialogue_balloon(final_dialogue_resource, final_dialogue_start)
		dialogues_ready.emit()
		DialogueManager.dialogue_ended.connect(_hide_top_portrait_once)

func _show_top_portrait() -> void:
	top_portrait.show()
	top_portrait.texture = portrait_neutral
	var t := create_tween()
	top_portrait.modulate.a = 0.0
	t.tween_property(top_portrait, "modulate:a", 1.0, 0.25)

func _hide_top_portrait_once(res : DialogueResource) -> void:
	if res == final_dialogue_resource:
		DialogueManager.dialogue_ended.disconnect(_hide_top_portrait_once)
		_current_balloon = null
		_last_dialogue_line = null
		var t := create_tween()
		t.tween_property(top_portrait, "modulate:a", 0.0, 0.25)
		t.tween_callback(Callable(top_portrait, "hide"))

func _update_top_portrait(line: DialogueLine) -> void:
	if not line or not top_portrait.visible or line.character.to_lower() != "bartender":
		top_portrait.texture = portrait_neutral
		return

	# Determine mood based on keywords in the dialogue text
	var mood: String = "neutral"
	if "simple" in line.text.to_lower() or "lying" in line.text.to_lower() or "favor" in line.text.to_lower():
		mood = "angry"

	# Update the portrait based on mood
	match mood:
		"neutral":
			top_portrait.texture = portrait_neutral
		"angry":
			top_portrait.texture = portrait_angry
