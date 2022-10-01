extends Label

signal timeUp

var timeLeft: int
var minLength: int

func _ready():
	setTime(16)

func updateText():
	text = Base.toBinaryString(timeLeft, minLength) +"s left"
	
func setTime(time):
	timeLeft = time
	minLength = Base.toBinaryString(timeLeft, 0).length()
	$Timer.start()
	updateText()

func _on_Timer_timeout():
	timeLeft -= 1
	if timeLeft == 0:
		emit_signal('timeUp')
	updateText()
