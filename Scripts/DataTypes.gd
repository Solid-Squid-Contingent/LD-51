extends Object

class_name DataTypes

class BulletType extends Reference:
	var speed = 80
	var sinAmplitude = 0#50
	var sinFrequency = 0#2
	var curve = 0
	var totalLifeTime = 10
	var homing = false
	var sprite = 'energy'
	
	static func fromDict(dict):
		var type = BulletType.new()
		type.speed = dict['speed']
		type.sinAmplitude = dict['sinAmplitude']
		type.sinFrequency = dict['sinFrequency']
		type.curve = dict['curve']
		type.totalLifeTime = dict['totalLifeTime']
		type.homing = dict['homing']
		type.sprite = dict['sprite']
		return type
	
	static func fromJSON(path):
		return fromDict(Base.parseJSONFile("res://Resources/Bullets/" + path + ".json"))

class EnemyType extends Reference:
	var speed = 5
	var spreadAngle = 20
	var spreadNumber = 3
	var burstNumber = 1
	var burstDistance = 0.2
	var aimAtPlayer = false
	var rotationPerSecond = 180
	var bulletType = BulletType.new()
	
	static func fromDict(dict):
		var type = EnemyType.new()
		type.speed = dict['speed']
		type.spreadAngle = dict['spreadAngle']
		type.spreadNumber = dict['spreadNumber']
		type.burstNumber = dict['burstNumber']
		type.burstDistance = dict['burstDistance']
		type.aimAtPlayer = dict['aimAtPlayer']
		type.rotationPerSecond = dict['rotationPerSecond']
		type.bulletType = BulletType.fromJSON(dict['bulletType'])
		return type
	
	static func fromJSON(path):
		return fromDict(Base.parseJSONFile("res://Resources/Enemies/" + path + ".json"))

class SpawnType extends Reference:
	var enemyType = EnemyType.new()
	var number = 1
	var delay = 1
	var startDelay = 0
	
	static func fromDict(dict):
		var type = SpawnType.new()
		type.enemyType = EnemyType.fromJSON(dict['enemyType'])
		type.number = dict['number']
		type.delay = dict['delay']
		type.startDelay = dict['startDelay']
		return type

class LevelType extends Reference:
	var spawn = []
	var players = ["teleporting"]
	var duration = 16
	
	static func fromDict(dict):
		var type = LevelType.new()
		type.players = dict['players']
		type.duration = dict['duration']
		for s in dict['spawn']:
			type.spawn.append(SpawnType.fromDict(s))
		return type
	
	static func fromJSON(path):
		return fromDict(Base.parseJSONFile("res://Resources/Levels/" + path + ".json"))
