extends CanvasLayer

signal start_game

func update_score(value):
	$Score.text = str(value)
	
func update_timer(value):
	$Time.text = str(value)
	
func _on_button_pressed():
	$StartButton.hide()
	$Message.hide()
	start_game.emit()
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$Timer.start()

func _on_timer_timeout():
	$Message.hide()

func show_game_over():
	show_message("Game Over")
	await $Timer.timeout
	$StartButton.show()
	$Message.text = "Coin Dash!"
	$Message.show()
