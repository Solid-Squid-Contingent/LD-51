extends ParallaxBackground

const dist = Vector2(960, 540)

func _ready():
	for i in range(1,9):
		var p = ParallaxLayer.new()
		p.motion_scale = Vector2(i+1,i+1) * 0.1
		p.motion_offset = -dist * (1 - p.motion_scale.x)
		add_child(p)
		var s = Sprite.new()
		s.texture = load("res://Resources/Graphics/Backgrounds/Belt/Belt" + str(i) + ".png")
		s.position = dist
		s.scale = Vector2(1,1) * 8.0 / 3.0
		p.add_child(s)
