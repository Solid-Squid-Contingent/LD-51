extends Area2D

const speed = 5
const bulletSpeed = 80
const spreadAngle = 90
const spreadNumber = 5
const burstNumber = 10
const burstDistance = 0.2

const bulletScene = preload("res://Scenes/Bullet.tscn")

func _ready():
	call_deferred('shoot')

func _process(delta):
	position += Base.directionToClosest(self, 'player') * speed * delta


func _on_BulletTimer_timeout():
	shoot()

func shoot():
	var direction = Base.directionToClosest(self, 'player')
	if direction.length() > 0:
		for burst in range(burstNumber - 1):
			# warning-ignore:return_value_discarded
			get_tree().create_timer(burstDistance * burst).connect("timeout", self, "shoot_burst", [direction])
		shoot_burst(direction)

func shoot_burst(direction):
	for i in range(spreadNumber):
		var bullet = bulletScene.instance()
		bullet.position = self.position
		bullet.homing = true
		
		var angle = 0
		if spreadNumber > 1:
			angle = -spreadAngle/2.0 + i * spreadAngle / float(spreadNumber - 1)
		bullet.velocity = (direction * bulletSpeed).rotated(deg2rad(angle))
		
		get_parent().add_child(bullet)
		bullet.setSprite('homing')


func _on_Enemy_area_entered(area):
	area.queue_free()
	queue_free()
