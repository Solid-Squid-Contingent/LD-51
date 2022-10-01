extends Area2D

var sinAmplitude = 0#50
var sinFrequency = 0#2
var curve = 0
var totalLifeTime = 10

var homing = false

var velocity: Vector2
onready var realPosition = position

onready var sprites = {
	'energy' : $SpriteEnergy,
	'player' : $SpritePlayer,
	'homing' : $SpriteHoming,
	'straight' : $SpriteStraight,
}

onready var birthTime = Time.get_ticks_usec()

func _ready():
	material.set_shader_param("pixelSize", 2.0)

func lifeTime(): #in seconds
	return (Time.get_ticks_usec() - birthTime) / 1000000.0

func setSprite(name):
	sprites[name].visible = true

func _process(delta):
	if homing:
		velocity = Base.directionToClosest(self, 'player') * velocity.length()
	
	rotation = velocity.angle() + PI/2
	
	velocity = velocity.rotated(deg2rad(curve) * delta)
	realPosition += velocity * delta
	position = realPosition + sinAmplitude * sin(lifeTime() * sinFrequency) * velocity.normalized().rotated(PI/2)
	
	if totalLifeTime < lifeTime():
		queue_free()
	elif totalLifeTime - lifeTime() < 1:
		material.set_shader_param("disintegrationProgress", 1 - (totalLifeTime - lifeTime()))
		if totalLifeTime - lifeTime() < 0.5:
			self.monitorable = false
			self.monitoring = false
