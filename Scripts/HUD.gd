extends CanvasLayer

signal timeUp

func _on_TimeLeftLabel_timeUp():
	emit_signal('timeUp')

func setTime(time):
	$TimeLeftLabel.setTime(time)
