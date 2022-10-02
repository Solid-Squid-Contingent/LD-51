extends TextureProgress

func _process(_delta):
	material.set_shader_param("disintegrationProgress", 0.8 - value * 0.8)
