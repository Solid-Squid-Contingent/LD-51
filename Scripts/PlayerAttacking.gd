extends "res://Scripts/Player.gd"

const bulletScene = preload("res://Scenes/BulletPlayer.tscn")

const bulletSpeed = 300

func shoot():
	var direction = Base.directionToClosest(self, 'enemy')
	if direction.length() > 0:
		var bullet = bulletScene.instance()
		bullet.position = self.position
		bullet.velocity = (direction * bulletSpeed)
		get_parent().add_child(bullet)
		bullet.setSprite('player')
	
func move():
	.move()
	shoot()
	
	
