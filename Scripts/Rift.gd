extends Node2D

var rotationSpeed

func _ready():
	rotationSpeed = rand_range(0.5, 1)
	rotation = rand_range(0, 2*PI)
	material.set_shader_param("offsets", Color(randf(), randf(), randf()))

func _on_LifeTimer_timeout():
	queue_free()


func _process(delta):
	var timeLeft = $LifeTimer.time_left / $LifeTimer.wait_time
	rotation += rotationSpeed * delta
	
	if timeLeft < 0.5:
		material.set_shader_param("disintegrationProgress", 1 - timeLeft * 2)
