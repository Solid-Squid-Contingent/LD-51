extends Camera2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT


func zoomOnto(object, finalZoom, time):
	$ZoomTween.interpolate_property(self, "offset", self.offset, to_local(object.global_position), time, TRANS, EASE)
	$ZoomTween.interpolate_property(self, "zoom", self.zoom, Vector2(finalZoom, finalZoom), time, TRANS, EASE)
	$ZoomTween.start()

func reset(time):
	$ZoomTween.interpolate_property(self, "offset", self.offset, Vector2(0, 0), time, TRANS, EASE)
	$ZoomTween.interpolate_property(self, "zoom", self.zoom, Vector2(1, 1), time, TRANS, EASE)
	$ZoomTween.start()
