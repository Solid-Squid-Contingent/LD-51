extends Path2D

const enemyScene = preload("res://Scenes/Enemy.tscn")

onready var game = get_parent()

func loadSpawns(level):
	for spawnType in level.spawn:
		for i in range(spawnType.number):
			var delay = spawnType.delay * i + spawnType.startDelay
			# warning-ignore:return_value_discarded
			get_tree().create_timer(delay, false).connect("timeout", self, "spawnEnemy", [spawnType.enemyType])

func spawnEnemy(type):
	var pos = curve.interpolate_baked(randf() * curve.get_baked_length(), false)
	var enemy = enemyScene.instance()
	enemy.position = pos
	enemy.type = type
	game.enemyParent.add_child(enemy)
	game.connectEnemy(enemy)
