extends Node

class_name Base

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
