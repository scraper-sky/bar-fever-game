extends Area2D

@export var target_scene: String = "res://scenes/levels/level_2.tscn"  # Next level
@onready var transition_node = get_node("../TransitionLayer/TransitionRect")  # Adjusted path
@onready var transition_layer = get_node("../TransitionLayer")

func _ready():
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("flicker")
	if not transition_node or not transition_layer:
		print("Error: Transition nodes not found at path '../TransitionLayer'")
		get_parent().print_tree_pretty()
	else:
		print("Transition nodes found successfully")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name in ["MainPlayer", "MainPlayer2", "MainPlayer2Level18"]:
		call_deferred("start_transition_sequence")

func start_transition_sequence():
	await start_transition()
	if get_tree():  # Check if node is still in tree
		get_tree().change_scene_to_file(target_scene)
	queue_free()  # Safe to free after scene change

func start_transition() -> void:
	if not transition_node or not transition_layer:
		print("Transition nodes not found!")
		return
	
	# Force TransitionLayer to be visible at the start of the transition
	transition_layer.visible = true
	
	var shader_material = transition_node.material as ShaderMaterial
	if not shader_material:
		print("No shader material on transition node!")
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(shader_material, "shader_parameter/pixel_size", 100.0, 1.0)  # Extreme pixelation
	tween.parallel().tween_property(shader_material, "shader_parameter/fade", 2.0, 2.0)  # Fast fade
	tween.tween_callback(func(): print("Transition complete"))
	await tween.finished
	
	# Hide the TransitionLayer after transition
	transition_layer.visible = false
