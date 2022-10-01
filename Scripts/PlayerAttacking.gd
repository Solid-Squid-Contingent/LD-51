extends "res://Scripts/Player.gd"

const bulletScene = preload("res://Scenes/BulletPlayer.tscn")
var bulletType = DataTypes.BulletType.fromJSON('PlayerBullet')

const bulletSpeed = 300

func shoot():
	var direction = Base.directionToClosest(self, 'enemy')
	if direction.length() > 0:
		var bullet = bulletScene.instance()
		bullet.type = bulletType
		get_parent().add_child(bullet)
	
func move():
	.move()
	shoot()
	
	
