extends Node2D

# warning-ignore:unused_signal
signal restartGame()

const swipeScene = preload("res://Scenes/ClearSwipe.tscn")

onready var textbox = $"HUD/TextBox"

const playerScenes = {
	'teleport' : preload("res://Scenes/Player.tscn"),
	'move' : preload("res://Scenes/PlayerMoving.tscn"),
	'attack' : preload("res://Scenes/PlayerAttacking.tscn")
}

onready var playerPositions = {
	'teleport' : 	$Positions/PlayerTeleport,
	'move' : 		$Positions/PlayerMove,
	'attack' : 		$Positions/PlayerAttack
}

onready var playerParent = $Players
onready var enemyParent = $Enemies
onready var screenShaker = $Camera/ScreenShaker

var dialogProgress = 0
var tutorialProgress = 0
var dialog = []
var inMenu = true

func _input(event):
	if !inMenu and event.is_action_pressed("advance"):
		if not textbox.all_text_appeared():
			textbox.show_all_text()
		else:
			printNextDialogLine()
	elif !inMenu and event.is_action_pressed("skip_dialog"):
		textbox.show_all_text()
		dialogProgress = dialog.size()
		hideDialog()
	
func setTutorialProgress(newTutorialProgress):
	tutorialProgress = newTutorialProgress
	dialogProgress = 0
	get_parent().tutorialProgress = newTutorialProgress
	get_parent().saveProgress()
	
	loadLevel()
	loadTutorialSpecificNodes()

func progressInTutorial():
	setTutorialProgress(tutorialProgress + 1)


func loadTutorialSpecificNodes():
	pass

func loadDialog(filename):
	dialog = []
	
	var dialogFile = File.new()
	var fullFilename = "res://Resources/Dialog/"+filename+".txt"
		
	if not dialogFile.file_exists(fullFilename):
		push_warning("Dialog file "+fullFilename+" not found")
		return
	
	dialogFile.open(fullFilename, File.READ)
	while !dialogFile.eof_reached():
		var line = dialogFile.get_line()
		dialog.append(line)
	dialogFile.close()

func printNextDialogLine():
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

func enemyDied(_enemy):
	screenShaker.start()

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
		player.connect("died", self, "playerDied")
		
	$SpawnPath.loadSpawns(level)
	
	if not level.introDialog.empty():
		loadDialog(level.introDialog)
		printNextDialogLine()
	
func swipeDone():
	loadLevel()

func _on_HUD_timeUp():
	var swipe = swipeScene.instance()
	add_child(swipe)
	swipe.connect("done", self, "swipeDone")
	screenShaker.start(2, 40)

func playerDied(player):
	Engine.time_scale = 0.5
	var time = 2 * Engine.time_scale
	$Camera.zoomOnto(player, 0.2, time)
	for _i in range(80):
		Engine.time_scale *= 0.9
		yield(get_tree().create_timer(time * 0.3), "timeout")
		time *= 0.7
	yield(get_tree().create_timer(time), "timeout")
	Engine.time_scale = 1
	$Camera.reset(0.1)
	yield(get_tree().create_timer(0.1), "timeout")
	loadLevel()
