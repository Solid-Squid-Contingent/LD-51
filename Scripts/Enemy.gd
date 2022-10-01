extends Area2D

const speed = 5
const bulletSpeed = 100

const bulletScene = preload("res://Scenes/Bullet.tscn")

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
	var direction = directionToClosestPlayer()
	if direction.length() > 0:
		var bullet = bulletScene.instance()
		get_parent().add_child(bullet)
		bullet.position = self.position
		bullet.velocity = direction * bulletSpeed
