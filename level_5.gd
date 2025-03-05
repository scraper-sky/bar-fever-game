extends Node2D

@onready var tile_map = $TileMapLayer
@onready var blue_portal = $BluePortal
var lamp_states = {}

func _ready():
	if not tile_map:
		print("Error: 'TileMapLayer' not found!")
		return
	if not blue_portal:
		print("Error: BluePortal not found!")
		return
	blue_portal.visible = false
	for i in range(5):
		for j in range(3):
			tile_map.set_cell(0, Vector2i(i, j), 1, Vector2i(0, 0))  # purpleland
	for i in range(5):
		for j in range(2):
			var tile_pos = Vector2i(i, j)
			var source_id = tile_map.get_cell_source_id(tile_pos)
			if source_id == -1:
				tile_map.set_cell(1, tile_pos, 2 + (i + j) % 2, Vector2i(0, 0))
			source_id = tile_map.get_cell_source_id(tile_pos)
			lamp_states[tile_pos] = (source_id == 3)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var player_pos = $MainPlayer.position
		var tile_pos = tile_map.local_to_map(player_pos)
		if lamp_states.has(tile_pos):
			toggle_lamp(tile_pos)

func toggle_lamp(tile_pos: Vector2i):
	lamp_states[tile_pos] = !lamp_states[tile_pos]
	var source_id = 3 if lamp_states[tile_pos] else 2
	tile_map.set_cell(1, tile_pos, source_id, Vector2i(0, 0))
	tile_map.set_cell(1, tile_pos + Vector2i(0, 1), source_id, Vector2i(0, 0))
	tile_map.set_cell(1, tile_pos + Vector2i(0, 2), source_id, Vector2i(0, 0))
	check_win()

func check_win():
	if lamp_states.values().all(func(state): return state):
		print("Puzzle solved!")
		blue_portal.visible = true
