extends Area2D

const speed = 5
const bulletSpeed = 150
const spreadAngle = 90
const spreadNumber = 5
const burstNumber = 10
const burstDistance = 0.2

const bulletScene = preload("res://Scenes/Bullet.tscn")

func _ready():
	call_deferred('shoot')

func getClosestPlayer():
	var closestPlayer = null
	var closestDistance = INF
	for player in self.get_tree().get_nodes_in_group('player'):
		var d = (player.position - position).length()
		if d < closestDistance:
			closestPlayer = player
			closestDistance = d
			
	return closestPlayer

func directionToClosestPlayer():
	var player = getClosestPlayer()
	if player != null:
		return (getClosestPlayer().position - position).normalized()
	return Vector2(0,0)

func _process(delta):
	position += directionToClosestPlayer() * speed * delta


func _on_BulletTimer_timeout():
	shoot()

func shoot():
	var direction = directionToClosestPlayer()
	if direction.length() > 0:
		for _burst in range(burstNumber):
			for i in range(spreadNumber):
				var bullet = bulletScene.instance()
				bullet.position = self.position
				
				var angle = 0
				if spreadNumber > 1:
					angle = -spreadAngle/2.0 + i * spreadAngle / float(spreadNumber - 1)
				bullet.velocity = (direction * bulletSpeed).rotated(deg2rad(angle))
				
				get_parent().add_child(bullet)
			yield(get_tree().create_timer(burstDistance), "timeout")
