extends Node2D

var lamp_blocks = {}
var lamp_states = {}

func _ready():
	$ObstacleBlock.show_block()

	var lamp_nodes = get_tree().get_nodes_in_group("lamp_blocks")
	if lamp_nodes.size() != 10:
		return
	for i in range(lamp_nodes.size()):
		var lamp = lamp_nodes[i]
		lamp_blocks[lamp.position] = lamp
		lamp.is_on = (i % 2) == 0 
		lamp_states[lamp.position] = lamp.is_on
		lamp.update_sprite()
	update_obstacle()

func toggle_adjacent(lamp_pos: Vector2):
	if lamp_blocks.has(lamp_pos):
		lamp_states[lamp_pos] = !lamp_states[lamp_pos]
		lamp_blocks[lamp_pos].toggle()
	var below_pos = lamp_pos + Vector2(0, 64)  # Down 64px
	if lamp_blocks.has(below_pos):
		lamp_states[below_pos] = !lamp_states[below_pos]
		lamp_blocks[below_pos].toggle()

	update_obstacle()

func update_obstacle():
	var all_on = true
	for pos in lamp_blocks.keys():
		if not lamp_states[pos]:
			all_on = false
			break
	if all_on:
		$ObstacleBlock.hide_block()
	else:
		$ObstacleBlock.show_block()
