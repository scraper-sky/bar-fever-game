extends Node2D

# You need to reference the node first
@onready var undreamer = $Undreamer  # Assuming "Undreamer" is a child node
# Can't have code outside functions
func _ready():
	undreamer.hide()

func _process(_delta):
	if Input.is_action_pressed("undream"):
		undreamer.show()
