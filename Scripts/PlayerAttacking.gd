extends "res://Scripts/Player.gd"

const bulletScene = preload("res://Scenes/Bullet.tscn")
var bulletType = DataTypes.BulletType.fromJSON('PlayerBullet')

const bulletSpeed = 300

func shoot():
	var direction = Base.directionToClosest(self, 'enemy')
	if direction.length() > 0:
		var bullet = bulletScene.instance()
		bullet.position = position
		bullet.direction = direction
		bullet.type = bulletType
		get_parent().add_child(bullet)
		$AttackPlayer.play()
	
func move():
	.move()
	if lives > 0:
		shoot()
	
	
