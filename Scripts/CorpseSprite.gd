extends Sprite

onready var velocity = Vector2(0, 100).rotated(randf() * PI)

func _process(delta):
	position += velocity * delta
	velocity *= 0.99
	
	var timeLeft = $Timer.time_left / $Timer.wait_time	
	if timeLeft < 0.5:
		material.set_shader_param("disintegrationProgress", 1 - timeLeft * 2)


func _on_Timer_timeout():
	queue_free()