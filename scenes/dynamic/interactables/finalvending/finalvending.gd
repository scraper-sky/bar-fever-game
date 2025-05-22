extends Area2D

# Reference to the sprite for visuals
@onready var sprite: Sprite2D = $Sprite2D
# Reference to the popup panel
@onready var popup: PopupPanel = $PopupPanel
# Reference to the error sound player
@onready var error_sound: AudioStreamPlayer2D = $ErrorSound
# Reference to the purchase sound player
@onready var purchase_sound: AudioStreamPlayer2D = $PurchaseSound

# Costs for each purchase option
const FIRST_COST: int = 100
const SECOND_COST: int = 300
const THIRD_COST: int = 2000

# Bounce parameters
const BOUNCE_AMPLITUDE: float = 10.0  # Height of the bounce in pixels
const BOUNCE_DURATION: float = 1.0    # Duration of one bounce cycle in seconds


var tween: Tween = null

func _ready() -> void:
	# Ensure popup is hidden and not initialized as visible
	popup.hide()
	popup.visible = false
	# Set retro size
	popup.size = Vector2(220, 140)
	# Connect signals for player interaction
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Connect popup buttons
	$PopupPanel/VBoxContainer/FirstButton.pressed.connect(_on_first_pressed)
	$PopupPanel/VBoxContainer/SecondButton.pressed.connect(_on_second_pressed)
	$PopupPanel/VBoxContainer/ThirdButton.pressed.connect(_on_third_pressed)
	# Start bouncing immediately
	start_bouncing()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# Show and center the popup only when player enters
		popup.popup_centered()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		# Hide the popup when player leaves
		popup.hide()
		popup.visible = false

func start_bouncing() -> void:
	if tween:
		tween.kill()  # Stop any existing tween
	tween = create_tween().set_loops()
	tween.tween_property(sprite, "position:y", sprite.position.y + BOUNCE_AMPLITUDE, BOUNCE_DURATION / 2.0)\
		 .set_ease(Tween.EASE_IN_OUT)\
		 .set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position:y", sprite.position.y - BOUNCE_AMPLITUDE, BOUNCE_DURATION / 2.0)\
		 .set_ease(Tween.EASE_IN_OUT)\
		 .set_trans(Tween.TRANS_SINE)

func _on_first_pressed() -> void:
	if GameState.deduct_coins(FIRST_COST):
		print("first button purchased")
		purchase_sound.play()
		popup.hide()
		popup.visible = false
		get_tree().change_scene_to_file("res://scenes/first_scene/beginmenu.tscn")
		#placeholder for now, implement a new scene later and link it here 
	else:
		error_sound.play()

func _on_second_pressed() -> void:
	if GameState.deduct_coins(SECOND_COST):
		print("first button purchased")
		purchase_sound.play()
		popup.hide()
		popup.visible = false
		get_tree().change_scene_to_file("res://scenes/first_scene/beginmenu.tscn")
		#placeholder for now, implement a new scene later and link it here 
	else:
		error_sound.play()

func _on_third_pressed() -> void:
	if GameState.deduct_coins(THIRD_COST):
		print("first button purchased")
		purchase_sound.play()
		popup.hide()
		popup.visible = false
		get_tree().change_scene_to_file("res://scenes/first_scene/beginmenu.tscn")
		#placeholder for now, implement a new scene later and link it here 
	else:
		error_sound.play()
