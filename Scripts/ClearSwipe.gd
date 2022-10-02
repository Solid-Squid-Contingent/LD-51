extends KinematicBody2D

signal done

func impact():
	return true

func _physics_process(delta):
	# warning-ignore:return_value_discarded
	move_and_collide(delta * Vector2(-2020, 0))
	if position.x < -50:
		emit_signal("done")
		queue_free()
