extends Label

signal timeUp

var timeLeft = 25

func _ready():
	updateText()

func updateText():
	text = Base.toBinaryString(timeLeft, 5) +"s left"

func _on_Timer_timeout():
	timeLeft -= 1
	if timeLeft == 0:
		emit_signal('timeUp')
	updateText()
