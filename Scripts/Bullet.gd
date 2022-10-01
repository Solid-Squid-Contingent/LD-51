extends Area2D


var velocity

func _process(delta):
	position += velocity * delta
