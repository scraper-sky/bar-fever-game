extends Node2D

@onready var tile_map = $TileMapLayer
@onready var blue_portal = $BluePortal
var lamp_states = {}
var tile_colors = {}

func _ready():
	if not tile_map:
		print("Error: 'TileMapLayer' not found!")
		return
	if not blue_portal:
		print("Error: BluePortal not found!")
		return
	blue_portal.visible = false
	# 5x2 grid, centers at 64x64 increments
	for i in range(5):
		for j in range(2):
			var pos = Vector2(32 + i * 64, 32 + j * 64)
			lamp_states[pos] = (i + j) % 2 == 0
			var lamp = preload("res://scenes/dynamic/lamp_block.tscn").instantiate()
			lamp.position = pos
			add_child(lamp)
	for pos in lamp_states.keys():
		tile_colors[pos + Vector2(0, 64)] = Color.GRAY
		tile_colors[pos + Vector2(0, 128)] = Color.GRAY
	update_tiles()

func toggle_adjacent(lamp_pos: Vector2):
	var tile1 = lamp_pos + Vector2(0, 64)
	var tile2 = lamp_pos + Vector2(0, 128)
	tile_colors[tile1] = Color.YELLOW if lamp_states[lamp_pos] else Color.GRAY
	tile_colors[tile2] = Color.YELLOW if lamp_states[lamp_pos] else Color.GRAY
	update_tiles()
	check_win()

func update_tiles():
	if not tile_map:
		print("'TileMapLayer' is null—cannot update tiles!")
		return
	for pos in tile_colors.keys():
		var tile_pos = tile_map.local_to_map(pos)
		# Layer 0: Base (purpleland.png)
		tile_map.set_cell(0, tile_pos, 1, Vector2i(0, 0))  # ID 1 for purpleland
		# Layer 1: Toggle state (lamp_block1 or lamp_block2)
		var source_id = 2 if tile_colors[pos] == Color.GRAY else 3  # 2 = gray, 3 = yellow
		tile_map.set_cell(1, tile_pos, source_id, Vector2i(0, 0))

func check_win():
	if lamp_states.values().all(func(state): return state):
		print("Puzzle solved!")
		blue_portal.visible = true
