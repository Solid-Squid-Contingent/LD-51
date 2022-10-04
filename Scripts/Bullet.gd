extends Area2D

var type: DataTypes.BulletType

var direction: Vector2
var offsetAngle = 0.0
onready var realPosition = position

onready var shapes = {
	'energy' : $ShapeEnergy,
	'energyDirected' : $ShapeDirected,
	'energyBig' : $ShapeBig,
	'player' : $ShapePlayer,
	'homing' : $ShapeHoming
}

var lifeTime = 0.0

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
		collision_mask = 1+16+32
		
	if type.sprite == 'energyBig':
		rotation = rand_range(0, 2*PI)

func impact():
	queue_free()
	return false

func _process(delta):
	lifeTime += delta
	if type.homing:
		direction = Base.directionToClosest(self, 'player')
	
	rotation = direction.angle() + PI/2
	
	direction = direction.rotated(deg2rad(type.curve + offsetAngle * type.curveSpread) * delta)
	realPosition += direction * type.speed * delta
	position = realPosition + type.sinAmplitude * sin(lifeTime * type.sinFrequency) * direction.rotated(PI/2)
	
	var timeLeft = type.totalLifeTime - lifeTime
	if timeLeft < 0:
		queue_free()
	elif timeLeft < 2:
		material.set_shader_param("disintegrationProgress", 1 - timeLeft/2)
		if timeLeft < 1.8:
			self.monitorable = false
			self.monitoring = false


func _on_Bullet_body_entered(_body):
	queue_free()
