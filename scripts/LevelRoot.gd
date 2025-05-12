extends Node2D
@onready var transition_node = $TransitionLayer/TransitionRect
@onready var transition_layer = $TransitionLayer
@onready var hud_label = $Hud/InteractionHint

func toggle_player_visibility(make_visible: bool):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Stop any running tweens on the player
		var tweens = get_tree().get_nodes_in_group("tween")
		for tween in tweens:
			if tween.is_valid() and tween.get("target") == player:
				tween.kill()
		player.visible = make_visible
		print("LevelRoot: Player visibility set to: ", make_visible)
	else:
		print("LevelRoot: Player not found")

func _ready():
	# Ensure the player is visible when the level loads
	toggle_player_visibility(true)
	if transition_node and transition_layer:
		# Ensure TransitionLayer is visible for fade-in
		transition_layer.visible = true
		start_fade_in()
	if hud_label:
		hud_label.visible = false

func start_fade_in() -> void:
	var shader_material = transition_node.material as ShaderMaterial
	if not shader_material:
		print("No shader material on transition node!")
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(shader_material, "shader_parameter/pixel_size", 4.0, 1.0)  # Shrink pixels
	tween.parallel().tween_property(shader_material, "shader_parameter/fade", 0.0, 1.0)  # Fade in
	tween.tween_callback(func(): print("Fade-in complete"))
	await tween.finished
	
	# Hide the TransitionLayer after fade-in
	transition_layer.visible = false
