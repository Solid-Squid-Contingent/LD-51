extends Node2D

func _ready():
	material.set_shader_param("offsets", Color(randf(), randf(), randf()))

func _on_LifeTimer_timeout():
	queue_free()


func _process(_delta):
	var timeLeft = $LifeTimer.time_left / $LifeTimer.wait_time
	
	if timeLeft <  0.5:
		self.modulate.a = timeLeft * 2
