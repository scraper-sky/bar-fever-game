class_name TwoStageDialogueController
extends Control

signal dialogues_ready

@export var dialogue_resource       : DialogueResource
@export var dialogue_start          : String = "start"
@export var dialogue_resource_2     : DialogueResource
@export var dialogue_start_2        : String = "start"
@export var final_dialogue_resource : DialogueResource
@export var final_dialogue_start    : String = "start"

# ─────────── just drag the node here; no get_node needed ───────────
@export var top_portrait : TextureRect          # ← set in Inspector

var _seen_first  : bool = false
var _seen_second : bool = false
var _final_fired : bool = false

func _ready() -> void:
	if top_portrait == null:
		push_error("top_portrait is not assigned in the Inspector!")
		return                               # fail early so you notice
	top_portrait.hide()                      # ensure it starts hidden
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_strange_paper_pressed() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_alcohol_bottles_pressed() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource_2, dialogue_start_2)

func _on_dialogue_ended(res : DialogueResource) -> void:
	if res == dialogue_resource:
		_seen_first = true
	elif res == dialogue_resource_2:
		_seen_second = true

	# Only continue when both first dialogues have finished
	if _seen_first and _seen_second and not _final_fired:
		_final_fired = true

		_show_top_portrait()                                # fade‑in now
		DialogueManager.show_dialogue_balloon(final_dialogue_resource,
											  final_dialogue_start)
		dialogues_ready.emit()

		# hide portrait after the final balloon ends
		DialogueManager.dialogue_ended.connect(_hide_top_portrait_once)


func _show_top_portrait() -> void:
	top_portrait.show()
	top_portrait.modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(top_portrait, "modulate:a", 1.0, 0.25)   # fade‑in


func _hide_top_portrait_once(res : DialogueResource) -> void:
	if res == final_dialogue_resource:
		DialogueManager.dialogue_ended.disconnect(_hide_top_portrait_once)

		var tw := create_tween()
		tw.tween_property(top_portrait, "modulate:a", 0.0, 0.25)   # fade‑out
		tw.tween_callback(Callable(top_portrait, "hide"))          # ← on Tween
