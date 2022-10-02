extends Node2D

signal timeUp

var timeLeft: int
var minLength: int

var sprites = []

const zeroTexture = preload("res://Resources/Graphics/Misc/number_0.png")
const oneTexture = preload("res://Resources/Graphics/Misc/number_1.png")

func _ready():
	setTime(15)

func updateText():
	for sprite in sprites:
		sprite.queue_free()
	sprites = []
	
	var text = Base.toBinaryString(timeLeft, minLength)
	
	var nextPosition = Vector2(0,0)
	for digit in text:
		var sprite = Sprite.new()
		sprite.centered = false
		if digit == "0":
			sprite.texture = zeroTexture
		else:
			sprite.texture = oneTexture
		sprite.position = nextPosition
		nextPosition.x += sprite.texture.get_size().x
		add_child(sprite)
		sprites.append(sprite)
	
func setTime(time):
	timeLeft = time
	minLength = Base.toBinaryString(timeLeft, 0).length()
	$Timer.start()
	updateText()

func _on_Timer_timeout():
	timeLeft -= 1
	if timeLeft == 0:
		emit_signal('timeUp')
	updateText()
