extends TextureProgress

var realValue: int

onready var flashTimer = $FlashTimer
onready var showTimer = $ShowTimer

func setLives(lives):
	if lives > 1:
		realValue = lives
		value = lives
		max_value = lives
		visible = true
		showTimer.start()
		material.set_shader_param("steps", lives)

func reduce():
	visible = true
	realValue -= 1
	flashTimer.start()
	showTimer.start()

func _process(_delta):
	var timerRatio = flashTimer.time_left / flashTimer.wait_time
	value = realValue + (int(timerRatio * 8.99 / 2.0) % 2)
	
	var ratio = float(realValue + timerRatio) / max_value
	material.set_shader_param("disintegrationProgress", 0.8 - ratio * 0.8)


func _on_ShowTimer_timeout():
	visible = false
