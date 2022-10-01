extends Particles2D

func _ready():
	emitting = true

func _process(_delta):
	var timeLeft = $Timer.time_left / $Timer.wait_time
	if timeLeft < 0.5:
		material.set_shader_param("disintegrationProgress", 1 - timeLeft * 2)

func _on_Timer_timeout():
	queue_free()
