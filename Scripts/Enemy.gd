extends Area2D

signal died

var type = DataTypes.EnemyType.new()

const bulletScene = preload("res://Scenes/Bullet.tscn")

func _ready():
	call_deferred('shoot')

func _process(delta):
	position += Base.directionToClosest(self, 'player') * type.speed * delta
	rotation += deg2rad(type.rotationPerSecond) * delta


func _on_BulletTimer_timeout():
	shoot()

func shoot():
	for burst in range(1, type.burstNumber):
		# warning-ignore:return_value_discarded
		get_tree().create_timer(type.burstDistance * burst).connect("timeout", self, "shoot_burst")
	shoot_burst()

func shoot_burst():
	var direction = Vector2(0,-1).rotated(rotation)
	if type.aimAtPlayer:
		direction = Base.directionToClosest(self, 'player')
	if direction.length() > 0:
		for i in range(type.spreadNumber):
			var bullet = bulletScene.instance()
			bullet.position = self.position
			#bullet.homing = true
			
			var angle = 0
			if type.spreadNumber > 1:
				angle = -type.spreadAngle/2.0 + i * type.spreadAngle / float(type.spreadNumber - 1)
			bullet.direction = direction.rotated(deg2rad(angle))
			bullet.type = type.bulletType
			
			get_parent().add_child(bullet)

func impact(object):
	object.impact()
	queue_free()
	emit_signal("died", self)
	Base.spawnDeathParticles(self)


func _on_Enemy_area_entered(area):
	impact(area)

func _on_Enemy_body_entered(body):
	impact(body)
