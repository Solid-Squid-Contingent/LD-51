extends Area2D

var type = DataTypes.BulletType.new()

var direction: Vector2
onready var realPosition = position

onready var sprites = {
	'energy' : $SpriteEnergy,
	'energyBig' : $SpriteEnergyBig,
	'player' : $SpritePlayer,
	'homing' : $SpriteHoming,
	'straight' : $SpriteStraight,
}

onready var birthTime = Time.get_ticks_usec()

func _ready():
	material.set_shader_param("pixelSize", 2.0)
	setSprite()

func setSprite():
	sprites[type.sprite].visible = true
	if type.sprite == 'energyBig':
		$CollisionShape.disabled = true
		$CollisionShapeBig.disabled = false
	else:
		$CollisionShape.disabled = false
		$CollisionShapeBig.disabled = true
	
	if type.sprite == 'player':
		collision_layer = 2
		collision_mask = 4
	else:
		collision_layer = 8
		collision_mask = 1
		

func lifeTime(): #in seconds
	return (Time.get_ticks_usec() - birthTime) / 1000000.0

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
