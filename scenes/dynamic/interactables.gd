extends Area2D

# you can also default this to 'true' if you only ever use it on map‑zones
@export var is_map: bool = true  
@export var hint_text: String = "Press E to open"

@onready var hud_layer := get_tree().current_scene.get_node("Hud/InteractionHint")
@onready var map_hint  := get_tree().current_scene.get_node("Hud/MapHint")

var player_in_range := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	map_hint.visible = false
	print("Interactable ready → is_map:", is_map)

func _process(_delta: float) -> void:
	# only listen for E if this really is a map, you're in range, and the hint is up
	if is_map and player_in_range and hud_layer.visible:
		if Input.is_action_just_pressed("interact"):
			toggle_map_hint()

func _on_body_entered(body: Node) -> void:
	if body.name.begins_with("MainPlayer"):
		player_in_range = true
		hud_layer.text    = hint_text
		hud_layer.visible = true
		print("Player entered, showing hint")

func _on_body_exited(body: Node) -> void:
	if body.name.begins_with("MainPlayer"):
		player_in_range    = false
		hud_layer.visible  = false
		map_hint.visible   = false
		print("Player exited, hiding everything")

func toggle_map_hint() -> void:
	map_hint.visible  = not map_hint.visible
	hud_layer.visible = not map_hint.visible
	print("Toggled map → now visible?", map_hint.visible)
