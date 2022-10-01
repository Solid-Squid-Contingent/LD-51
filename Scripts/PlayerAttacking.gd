extends "res://Scripts/Player.gd"

const bulletScene = preload("res://Scenes/BulletPlayer.tscn")

const bulletSpeed = 300


func getClosestEnemy():
	var closestEnemy = null
	var closestDistance = INF
	for enemy in self.get_tree().get_nodes_in_group('enemy'):
		var d = (enemy.position - position).length()
		if d < closestDistance:
			closestEnemy = enemy
			closestDistance = d
			
	return closestEnemy

func directionToClosestEnemy():
	var enemy = getClosestEnemy()
	if enemy != null:
		return (enemy.position - position).normalized()
	return Vector2(0,0)

func shoot():
	var direction = directionToClosestEnemy()
	if direction.length() > 0:
		var bullet = bulletScene.instance()
		bullet.position = self.position
		bullet.velocity = (direction * bulletSpeed)
		get_parent().add_child(bullet)
	
func move():
	.move()
	shoot()
	
	
