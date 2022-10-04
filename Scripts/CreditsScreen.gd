extends TextureRect

#signal button_pressed()
signal back_button_pressed()
signal screenClosed()


func popup():
	visible = true
	$MarginContainer/YesButton.grab_focus()

func _on_YesButton_pressed():
	visible = false
	emit_signal("screenClosed")
	emit_signal("back_button_pressed")
