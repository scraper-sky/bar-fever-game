extends Node2D

var lamp_blocks = {}
var lamp_states = {}

func _ready():
	print("Scene tree children:", get_child_count(), "Nodes:", get_children())
	if not $BluePortal:
		print("Error: BluePortal not found!")
		return
	if not $ObstacleBlock:
		print("Error: ObstacleBlock not found!")
		return
	$ObstacleBlock.show_block()
	print("Obstacle position:", $ObstacleBlock.position, "Visible:", $ObstacleBlock.visible)

	var lamp_nodes = get_tree().get_nodes_in_group("lamp_blocks")
	print("Lamp nodes found:", lamp_nodes.size(), "Nodes:", lamp_nodes)
	if lamp_nodes.size() != 10:
		print("Error: Expected 10 LampBlock instances, found ", lamp_nodes.size())
		return
	for i in range(lamp_nodes.size()):
		var lamp = lamp_nodes[i]
		lamp_blocks[lamp.position] = lamp
		lamp.is_on = (i % 2) == 0  # 5 on, 5 off
		lamp_states[lamp.position] = lamp.is_on
		lamp.update_sprite()
	update_obstacle()

func toggle_adjacent(lamp_pos: Vector2):
	# Toggle the lamp itself
	if lamp_blocks.has(lamp_pos):
		lamp_states[lamp_pos] = !lamp_states[lamp_pos]
		lamp_blocks[lamp_pos].toggle()
		print("Toggled lamp at:", lamp_pos)

	# Toggle lamp directly below (in 5x2 grid)
	var below_pos = lamp_pos + Vector2(0, 64)  # Down 64px
	if lamp_blocks.has(below_pos):
		lamp_states[below_pos] = !lamp_states[below_pos]
		lamp_blocks[below_pos].toggle()
		print("Toggled below at:", below_pos)

	update_obstacle()

func update_obstacle():
	var all_on = true
	for pos in lamp_blocks.keys():
		if not lamp_states[pos]:
			all_on = false
			break
	print("All on:", all_on, "Obstacle visible:", $ObstacleBlock.visible)
	if all_on:
		print("Puzzle solved!")
		$ObstacleBlock.hide_block()
	else:
		$ObstacleBlock.show_block()
