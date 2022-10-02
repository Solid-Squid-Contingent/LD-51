extends Area2D

func _ready():
	$Particles.emitting = true

func _process(delta):
	$Shape.shape.radius += delta * 500


func _on_Timer_timeout():
	queue_free()

func impact():
	return true


func _on_LocalClear_area_entered(area):
	area.queue_free()
