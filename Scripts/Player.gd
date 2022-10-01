extends Area2D

onready var target = $Target
onready var moveTimer = $MoveTimer
onready var chargeProgressBar = $ChargeProgress

const movementRange = 150

func _input(event):
	if event.is_action_pressed('move') or (event is InputEventMouseMotion and Input.is_action_pressed('move')):
		moveTo(event.position)

func _process(_delta):
	chargeProgressBar.value = 1 - moveTimer.time_left / moveTimer.wait_time

func moveTo(targetPos):
	if (targetPos - position).length() < movementRange:
		target.visible = true
		target.position = targetPos - position


func _on_MoveTimer_timeout():
	if target.visible:
		position += target.position
		target.visible = false


func _on_Player_area_entered(area):
	area.queue_free()
	queue_free()
