extends Node

class_name Base

const deathParticleScene = preload("res://Scenes/DeathParticles.tscn")

static func spawnDeathParticles(caller):
	var particles = deathParticleScene.instance()
	particles.position = caller.position
	caller.get_parent().add_child(particles)

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

static func toBinaryString(i):
	if i == 0:
		return "0"
	var string = ""
	while i > 0:
		if i % 2:
			string = "1" + string
		else:
			string = "0" + string
		i /= 2
	return string
