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
		Engine.time_scale = 0.2
		timeScaled = true

func _process(_delta):
	if not disappearTimer.is_stopped():
		var timeLeft = disappearTimer.time_left / disappearTimer.wait_time
		$Full.material.set_shader_param("disintegrationProgress", 1.0 - timeLeft)


func _on_ShowTimer_timeout():
	visible = false

const TRANS = Tween.TRANS_QUAD
const EASE = Tween.EASE_OUT

func _on_DisappearTimer_timeout():
	if timeScaled:
		Engine.time_scale = 1
		$Tween.interpolate_property(Engine, "time_scale", Engine.time_scale, 1, 1, TRANS, EASE)
		$Tween.start()
	$Full.material.set_shader_param("disintegrationProgress", 1.0)
