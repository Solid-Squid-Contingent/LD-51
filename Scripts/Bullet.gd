extends Area2D

var type: DataTypes.BulletType

var direction: Vector2
onready var realPosition = position

onready var shapes = {
	'energy' : $ShapeEnergy,
	'energyBig' : $ShapeBig,
	'player' : $ShapePlayer,
	'homing' : $ShapeHoming
}

onready var birthTime = Time.get_ticks_usec()

func _ready():
	material.set_shader_param("pixelSize", 2.0)
	$TrailParticles.emitting = type.trail
	setSprite()

func setSprite():
	shapes[type.sprite].visible = true
	shapes[type.sprite].disabled = false
	
	if type.sprite == 'player':
		collision_layer = 2
		collision_mask = 4
	else:
		collision_layer = 8
		collision_mask = 1
		

func lifeTime(): #in seconds
	return (Time.get_ticks_usec() - birthTime) / 1000000.0

func impact():
	queue_free()

func _process(delta):
	if type.homing:
		direction = Base.directionToClosest(self, 'player')
	
	rotation = direction.angle() + PI/2
	
	direction = direction.rotated(deg2rad(type.curve) * delta)
	realPosition += direction * type.speed * delta
	position = realPosition + type.sinAmplitude * sin(lifeTime() * type.sinFrequency) * direction.rotated(PI/2)
	
	var timeLeft = type.totalLifeTime - lifeTime() 
	if timeLeft < 0:
		queue_free()
	elif timeLeft < 1:
		material.set_shader_param("disintegrationProgress", 1 - timeLeft)
		if timeLeft < 0.5:
			self.monitorable = false
			self.monitoring = false


func _on_Bullet_body_entered(_body):
	queue_free()
