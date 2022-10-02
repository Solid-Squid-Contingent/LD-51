extends Object

class_name DataTypes

class BulletType extends Reference:
	var speed = 80
	var sinAmplitude = 0#50
	var sinFrequency = 0#2
	var curve = 0
	var totalLifeTime = 10
	var homing = false
	var trail = true
	var sprite = 'energy'
	
	static func fromDict(dict):
		var type = BulletType.new()
		type.speed = dict['speed']
		type.sinAmplitude = dict['sinAmplitude']
		type.sinFrequency = dict['sinFrequency']
		type.curve = dict['curve']
		type.totalLifeTime = dict['totalLifeTime']
		type.homing = dict['homing']
		type.trail = dict['trail']
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
	var bulletWaveTime = 0.5
	var aimAtPlayer = false
	var rotationPerSecond = 180
	var lives = 1
	var bulletType = BulletType.new()
	var spriteName = ""
	var spriteScale : float
	var halfSpriteDirection: Vector2
	var nextForm = ""
	
	const halfSpriteDirectionDict = {
		"Junk1" : Vector2(-1,0),
		"Junk2" : Vector2(1,0),
		"Generic" : Vector2(-1,0),
		"SkullPhase1" : Vector2(),
		"SkullPhase2" : Vector2(-1,-1),
	}
	
	const spriteScaleDict = {
		"Junk1" : 2,
		"Junk2" : 2,
		"Generic" : 1,
		"SkullPhase1" : 2,
		"SkullPhase2" : 2,
	}
	
	static func fromDict(dict):
		var type = EnemyType.new()
		type.speed = dict['speed']
		type.spreadAngle = dict['spreadAngle']
		type.spreadNumber = dict['spreadNumber']
		type.burstNumber = dict['burstNumber']
		type.burstDistance = dict['burstDistance']
		type.bulletWaveTime = dict['bulletWaveTime']
		type.aimAtPlayer = dict['aimAtPlayer']
		type.rotationPerSecond = dict['rotationPerSecond']
		type.lives = dict['lives']
		type.bulletType = BulletType.fromJSON(dict['bulletType'])
		type.spriteName = dict['sprite']
		type.spriteScale = spriteScaleDict[type.spriteName]
		type.halfSpriteDirection = halfSpriteDirectionDict[type.spriteName]
		type.nextForm = dict['nextForm']
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
	var background : String
	var introDialog = ""
	
	static func fromDict(dict):
		var type = LevelType.new()
		type.players = dict['players']
		type.duration = dict['duration']
		type.background = dict['background']
		type.introDialog = dict['introDialog']
		for s in dict['spawn']:
			type.spawn.append(SpawnType.fromDict(s))
		return type
	
	static func fromJSON(path):
		return fromDict(Base.parseJSONFile("res://Resources/Levels/" + path + ".json"))
