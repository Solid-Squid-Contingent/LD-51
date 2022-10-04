extends Path2D

const enemyScene = preload("res://Scenes/Enemy.tscn")

onready var game = get_parent()

func loadSpawns(level):
	for child in get_children():
		child.queue_free()
		
	for spawnType in level.spawn:
		for i in range(spawnType.number):
			var delay = spawnType.delay * i + spawnType.startDelay
			if delay == 0:
				spawnEnemy(spawnType.enemyType)
			else:
				var timer = Timer.new()
				# warning-ignore:return_value_discarded
				timer.connect("timeout", self, "spawnEnemy", [spawnType.enemyType])
				timer.one_shot = true
				add_child(timer)
				timer.start(delay)

var lastOffset = -100
func spawnEnemy(type):
	var offset = randf()
	while abs(offset - lastOffset) < 0.1:
		offset = randf()
	lastOffset = offset
	var pos = curve.interpolate_baked(offset * curve.get_baked_length(), false)
	var enemy = enemyScene.instance()
	enemy.position = pos
	enemy.type = type
	game.enemyParent.add_child(enemy)
	game.connectEnemy(enemy)
