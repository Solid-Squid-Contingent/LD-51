extends Particles2D

func stopGraze(area):
	if area == get_parent():
		queue_free()
