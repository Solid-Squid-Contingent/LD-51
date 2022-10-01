extends Area2D

const sinAmplitude = 50
const sinFrequency = 2
const curve = 0
const totalLifeTime = 20

var velocity: Vector2
onready var realPosition = position

onready var birthTime = Time.get_ticks_usec()

func lifeTime(): #in seconds
	return (Time.get_ticks_usec() - birthTime) / 1000000.0

func _process(delta):
	velocity = velocity.rotated(deg2rad(curve) * delta)
	realPosition += velocity * delta
	position = realPosition + sinAmplitude * sin(lifeTime() * sinFrequency) * velocity.normalized().rotated(PI/2)
	
	if totalLifeTime < lifeTime():
		queue_free()
	elif totalLifeTime - lifeTime() < 1:
		self.modulate.a = totalLifeTime - lifeTime()
		if totalLifeTime - lifeTime() < 0.5:
			self.monitorable = false
			self.monitoring = false
