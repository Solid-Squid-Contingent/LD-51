extends "res://Scripts/Player.gd"

var targetPosition = Vector2(0,0)
var speed = 0

func _process(delta):
	var movement = delta * speed * (targetPosition - global_position).normalized()
	position += movement
	moveRadiusSprite.position -= movement
	target.position -= movement

func move():
	if target.visible:
		targetPosition = target.global_position
		moveRadiusSprite.position = target.position
		speed = target.position.length() / moveTimer.wait_time
		target.visible = false
		updateRadii()
	else:
		targetPosition = Vector2(0,0)
		speed = 0
