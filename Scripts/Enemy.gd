extends Area2D

signal died
signal hit

var type = DataTypes.EnemyType.new()
var livesLeft = 1

var game

const bulletScene = preload("res://Scenes/Bullet.tscn")
var enemyScene = load("res://Scenes/Enemy.tscn")

func _ready():
	call_deferred('shoot')
	$Sprite.texture = load("res://Resources/Graphics/Ships/" + type.spriteName + "/ship.png")
	$Sprite.scale = Vector2(type.spriteScale, type.spriteScale)
	$BulletTimer.wait_time = type.bulletWaveTime
	$BulletTimer.start()
	$Health.setLives(type.lives)
	livesLeft = type.lives

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
	if is_queued_for_deletion() or object.is_queued_for_deletion():
		return
		
	object.impact()
	livesLeft -= 1
	if livesLeft > 0:
		$Health.reduce()
		emit_signal("hit", self)
		Base.spawnDeathParticles(self)
	else:
		if not type.nextForm.empty():
			var enemy = enemyScene.instance()
			enemy.position = position
			enemy.type = DataTypes.EnemyType.fromJSON(type.nextForm)
			get_parent().call_deferred("add_child", enemy)
			game.connectEnemy(enemy)
		else:
			Base.spawnHalfSprites(self, type.spriteName, type.halfSpriteDirection, type.spriteScale)
			
		queue_free()
		emit_signal("died", self)
		Base.spawnDeathParticles(self)


func _on_Enemy_area_entered(area):
	impact(area)

func _on_Enemy_body_entered(body):
	impact(body)
