extends Object

class_name Base

const deathParticleScene = preload("res://Scenes/DeathParticles.tscn")
const corpseSpriteScene = preload("res://Scenes/CorpseSprite.tscn")

static func parseJSONFile(path):
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	return parse_json(content)

static func spawnDeathParticles(caller):
	var particles = deathParticleScene.instance()
	particles.position = caller.position
	caller.get_parent().add_child(particles)

static func spawnHalfSprites(caller, spriteName, halfSpriteDirection, scale=1):
	var extraAngle = halfSpriteDirection.angle_to(Vector2(0, 1))
	
	var half2 = corpseSpriteScene.instance()
	half2.texture = load("res://Resources/Graphics/Ships/" + spriteName + "/part_2.png")
	half2.position = caller.position
	half2.scale = Vector2(scale, scale)
	caller.get_parent().add_child(half2)
	half2.velocity = half2.velocity.rotated(-extraAngle + PI)
	
	var half1 = corpseSpriteScene.instance()
	half1.texture = load("res://Resources/Graphics/Ships/" + spriteName + "/part_1.png")
	half1.position = caller.position
	half1.scale = Vector2(scale, scale)
	caller.get_parent().add_child(half1)
	half1.velocity = half1.velocity.rotated(-extraAngle)

static func getClosest(caller, group):
	var closest = null
	var closestDistance = INF
	for object in caller.get_tree().get_nodes_in_group(group):
		var d = (object.position - caller.position).length()
		if d < closestDistance:
			closest = object
			closestDistance = d
			
	return closest

static func directionToClosest(caller, group):
	var closest = getClosest(caller, group)
	if closest != null:
		return (closest.position - caller.position).normalized()
	return Vector2(0,0)

static func toBinaryString(i, minLength):
	var string = ""
	while i > 0:
		if i % 2:
			string = "1" + string
		else:
			string = "0" + string
		i /= 2
	
	while string.length() < minLength:
		string = "0" + string
		
	return string
