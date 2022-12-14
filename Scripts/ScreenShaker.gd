extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0

onready var camera = get_parent()

func start(duration = 0.3, frequency = 20, newAmplitude = 25):
	amplitude = max(amplitude, newAmplitude)
	$Duration.wait_time = max($Duration.time_left, duration)
	$Frequency.wait_time = min($Frequency.wait_time, 1 / float(frequency))
	$Duration.start()
	$Frequency.start()
	
	new_shake()

func new_shake():
	if camera.zooming:
		$Duration.stop()
		$Frequency.stop()
		amplitude = 0
		$Frequency.wait_time = 1
		return
		
	var randomOffset = Vector2(rand_range(amplitude, -amplitude),
								 rand_range(amplitude, -amplitude))
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, randomOffset, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func reset():
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	amplitude = 0
	$Frequency.wait_time = 1

func _on_Frequency_timeout():
	new_shake()


func _on_Duration_timeout():
	reset()
	$Frequency.stop()

