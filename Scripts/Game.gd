extends Node2D

# warning-ignore:unused_signal
signal gameFinished()
signal dramaticZoomDone()
signal hideDialog()

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

onready var backgrounds = {
	'Belt' : 	$Backgrounds/Belt,
	'Planets' : $Backgrounds/Planets,
	'Space' : 	$Backgrounds/Space,
	'Station' : $Backgrounds/Station
}

onready var playerParent = $Players
onready var enemyParent = $Enemies
onready var screenShaker = $Camera/ScreenShaker

var bossFight = false
var gameOver = false

var dialogProgress = 0
var tutorialProgress = 0
var dialog = []
var inMenu = true

func _input(event):
	if !inMenu and event.is_action_pressed("advance"):
		if textbox.visible:
			$TextProceedPlayer.play()
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
	
	if tutorialProgress >= 19:
		emit_signal("gameFinished")
	else:
		loadLevel()

func progressInTutorial():
	setTutorialProgress(tutorialProgress + 1)


func loadDialog(filename):
	dialog = []
	
	if filename == "":
		return
	
	var dialogFile = File.new()
	var fullFilename = "res://Resources/Dialog/"+filename+".txt"
		
	if not dialogFile.file_exists(fullFilename):
		push_warning("Dialog file "+fullFilename+" not found")
		return
	
	dialogFile.open(fullFilename, File.READ)
	dialog = [dialogFile.get_as_text()]
#	while !dialogFile.eof_reached():
#		var line = dialogFile.get_line()
#		dialog.append(line)
	dialogFile.close()

func printNextDialogLine():
	if dialogProgress >= dialog.size():
		hideDialog()
	else:
		showDialog(dialog[dialogProgress])
		dialogProgress += 1

func hideDialog():
	textbox.hide()
	get_tree().paused = false
	emit_signal("hideDialog")
	

func showDialog(line):
	textbox.set_text(line)
	textbox.set_name("Captain's Log")
	textbox.show()
	get_tree().paused = true

func enemyDied(enemy):
	screenShaker.start(0.5)
	if bossFight and !gameOver and enemy.type.nextForm.empty():
		dramaticZoom(enemy)
		yield(self, "dramaticZoomDone")
		loadDialog("End")
		dialogProgress = 0
		printNextDialogLine()
		yield(self, "hideDialog")
		progressInTutorial()
	
func enemyHit(_enemy):
	screenShaker.start(0.2, 20, 15)

func loadLevel():
	gameOver = false
	if tutorialProgress == 0:
		return
	
	var level = DataTypes.LevelType.fromJSON("Level" + str(tutorialProgress))
	$HUD.setTime(level.duration)
	bossFight = (level.duration == 0)
	for bg in backgrounds:
		if bg == level.background:
			backgrounds[bg].visible = true
			backgrounds[bg].get_node("Music").play()
		else:
			backgrounds[bg].visible = false
			backgrounds[bg].get_node("Music").stop()
	
	for child in playerParent.get_children():
		child.queue_free()
	for child in enemyParent.get_children():
		child.queue_free()
		
	for playerName in level.players:
		var player = playerScenes[playerName].instance()
		player.position = playerPositions[playerName].position
		playerParent.add_child(player)
		player.connect("died", self, "playerDied")
		player.connect("hit", self, "playerHit")
		
	$SpawnPath.loadSpawns(level)
	
	loadDialog(level.introDialog)
	printNextDialogLine()

func connectEnemy(enemy):
	enemy.game = self
	enemy.connect("died", self, "enemyDied")
	enemy.connect("hit", self, "enemyHit")
	enemy.connect("attack", self, "enemyAttack")
	enemy.connect("burstAttack", self, "enemyBurstAttack")

func enemyAttack():
	$EnemyAttackPlayer.play()

func enemyBurstAttack():
	$EnemyBurstAttackPlayer.play()
	
func swipeDone():
	progressInTutorial()

func _on_HUD_timeUp():
	var swipe = swipeScene.instance()
	playerParent.add_child(swipe)
	swipe.connect("done", self, "swipeDone")
	screenShaker.start(1, 40)
	$TimeUpPlayer.play()

func dramaticZoom(object):
	Base.setTimeScale(get_tree(), 0.5)
	var time = 2 * Engine.time_scale
	$Camera.zoomOnto(object, 0.2, time)
	for _i in range(75):
		Base.setTimeScale(get_tree(), Engine.time_scale * 0.9)
		yield(get_tree().create_timer(time * 0.3), "timeout")
		time *= 0.7
	yield(get_tree().create_timer(time), "timeout")
	emit_signal("dramaticZoomDone")
	$Camera.reset(0.1* Engine.time_scale)
	yield(get_tree().create_timer(0.1* Engine.time_scale), "timeout")
	Base.setTimeScale(get_tree(), 1)

func playerDied(player):
	self.get_tree().set_group_flags(SceneTree.GROUP_CALL_REALTIME, 'player', 'gameOver', true)
	gameOver = true
	dramaticZoom(player)
	yield(self, "dramaticZoomDone")
	loadLevel()
	
func playerHit(_player):
	screenShaker.start(1)
