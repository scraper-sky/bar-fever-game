extends CharacterBody2D

@export var follow_distance: float = 50.0
@export var speed: float = 200.0
@export var catch_cooldown: float = 0.5  # Cooldown after catching the player
@onready var player = find_player()
@onready var animated_sprite = $Visual

var position_history: Array = []
var history_length: int = 0
var catch_timer: float = 0.0  # Timer to track cooldown

func find_player() -> CharacterBody2D:
	var tree = get_tree()
	if tree == null:
		return null
	var nodes = tree.get_nodes_in_group("player")
	if nodes.is_empty():
		push_error("No nodes found in group 'player'. Add MainPlayer2 to the 'player' group.")
		return null
	return nodes[0] as CharacterBody2D

func _ready() -> void:
	if player == null:
		push_error("Player not found. Ensure MainPlayer2 is in the scene and added to the 'player' group.")
		return
	
	print("ChasingMob: Found player at ", player.position)
	history_length = int((follow_distance / speed) * 60.0)
	animated_sprite.play("float")

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	# Update catch cooldown timer
	if catch_timer > 0:
		catch_timer -= delta
	
	position_history.append(player.position)
	
	if position_history.size() > history_length:
		var target_position = position_history[0]
		position_history.pop_front()
		
		var direction = (target_position - position).normalized()
		velocity = direction * speed
		
		# Flip the sprite based on movement direction
		if direction.x < 0:
			animated_sprite.flip_h = true  # Face left
		elif direction.x > 0:
			animated_sprite.flip_h = false  # Face right
		
		# When player stops, ChasingMob moves right by default
		if player.velocity.length() < 10.0:
			velocity = Vector2(speed, 0)
			animated_sprite.speed_scale = 1.5
			animated_sprite.flip_h = false  # Face right when moving right
		else:
			animated_sprite.speed_scale = 1.0
		
		move_and_slide()
	
	# Only check for collisions if not on cooldown
	if catch_timer <= 0:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider() == player:
				print("Mob caught player: ChasingMob")
				# Reset player position and physics state
				player.position = Vector2(100, 200)
				player.velocity = Vector2.ZERO
				position_history.clear()
				# Move ChasingMob farther back to avoid immediate collision
				position = player.position - Vector2(follow_distance + 20, 0)
				catch_timer = catch_cooldown
				# After catching, flip based on new relative position
				if position.x < player.position.x:
					animated_sprite.flip_h = false  # Face right toward player
				else:
					animated_sprite.flip_h = true  # Face left toward player
				break
