extends Node2D

# warning-ignore:unused_signal
signal restartGame()

const enemyScene = preload("res://Scenes/Enemy.tscn")
const swipeScene = preload("res://Scenes/ClearSwipe.tscn")

onready var textbox = $"HUD/TextBox"

const playerScenes = {
	'teleport' : preload("res://Scenes/Player.tscn"),
	'move' : preload("res://Scenes/PlayerMoving.tscn"),
	'attack' : preload("res://Scenes/PlayerAttacking.tscn")
}

onready var playerPositions = {
	'teleport' : $PlayerTeleport,
	'move' : $PlayerMove,
	'attack' : $PlayerAttack
}

onready var playerParent = $Players
onready var enemyParent = $Enemies
onready var screenShaker = $Camera/ScreenShaker

var dialogProgress = 0
var tutorialProgress = 0
var dialog = []
var inMenu = true

func _ready():
	loadLevel() #TODO

func _input(event):
	if !inMenu and event.is_action_pressed("advance"):
		if not textbox.all_text_appeared():
			textbox.show_all_text()
		else:
			print_next_dialog_line()
	elif !inMenu and event.is_action_pressed("skip_dialog"):
		textbox.show_all_text()
		dialogProgress = dialog.size()
		hideDialog()
	
func setTutorialProgress(newTutorialProgress):
	tutorialProgress = newTutorialProgress
	dialogProgress = 0
	get_parent().tutorialProgress = newTutorialProgress
	get_parent().saveProgress()
		
	loadDialog()
	loadTutorialSpecificNodes()

func progressInTutorial():
	setTutorialProgress(tutorialProgress + 1)
	print_next_dialog_line()


func loadTutorialSpecificNodes():
	loadLevel()

func loadDialog():
	dialog = []
	
	var dialogFile = File.new()
	var filename = "res://Resources/Dialog/"+str(tutorialProgress)+".txt"
		
	if not dialogFile.file_exists(filename):
		return
	
	dialogFile.open(filename, File.READ)
	while !dialogFile.eof_reached():
		var line = dialogFile.get_line()
		dialog.append(line)
	dialogFile.close()

func print_next_dialog_line():
	if dialogProgress >= dialog.size():
		hideDialog()
	else:
		showDialog(dialog[dialogProgress])
		dialogProgress += 1

func hideDialog():
	textbox.visible = false
	get_tree().paused = false
	

func showDialog(line):
	textbox.set_text(line)
	textbox.set_name("Mysterious Voice")
	textbox.visible = true
	get_tree().paused = true

func enemyDied():
	screenShaker.start()

func spawn_enemy(type):
	var pos = $SpawnPath.curve.interpolate_baked(randf() * $SpawnPath.curve.get_baked_length(), false)
	var enemy = enemyScene.instance()
	enemy.position = pos
	enemy.type = type
	enemyParent.add_child(enemy)
	enemy.connect("died", self, "enemyDied")

func loadLevel():
	var level = DataTypes.LevelType.fromJSON("Level1")
	$HUD.setTime(level.duration)
	$Background.texture = level.background
	
	for child in playerParent.get_children():
		child.queue_free()
	for child in enemyParent.get_children():
		child.queue_free()
		
	for playerName in level.players:
		var player = playerScenes[playerName].instance()
		player.position = playerPositions[playerName].position
		playerParent.add_child(player)
	for spawnType in level.spawn:
		for i in range(spawnType.number):
			var delay = spawnType.delay * i + spawnType.startDelay
			# warning-ignore:return_value_discarded
			get_tree().create_timer(delay).connect("timeout", self, "spawn_enemy", [spawnType.enemyType])
		
func swipeDone():
	loadLevel()

func _on_HUD_timeUp():
	var swipe = swipeScene.instance()
	add_child(swipe)
	swipe.connect("done", self, "swipeDone")
