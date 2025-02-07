extends Timer


func show_message(text):
	$Message.text = text
	$Message.show()
	$Timer.start()

func _on_timer_timeout():
	$Message.hide()
