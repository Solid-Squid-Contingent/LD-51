extends Node2D

onready var showTimer = $ShowTimer
onready var disappearTimer = $DisappearTimer

var timeScaled = false

func show():
	showTimer.start()
	visible = true

func disappear(moreLeft):
	disappearTimer.start()
	if moreLeft:
		Engine.time_scale = 0.5
		timeScaled = true

func _process(_delta):
	if not disappearTimer.is_stopped():
		var timeLeft = disappearTimer.time_left / disappearTimer.wait_time
		$Full.material.set_shader_param("disintegrationProgress", 1.0 - timeLeft)


func _on_ShowTimer_timeout():
	visible = false


func _on_DisappearTimer_timeout():
	if timeScaled:
		Engine.time_scale = 1
	$Full.material.set_shader_param("disintegrationProgress", 1.0)
