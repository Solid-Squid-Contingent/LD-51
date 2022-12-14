extends Node2D

export(String, FILE) var saveFileName = "user://Save.save"

var gameScene = load("res://Scenes/Game.tscn")
var tutorialProgress = 0
var previousPauseState
var game = null

func _ready():
	loadProgress()
	if tutorialProgress != 0:
		$"MenuScreenLayer/StartMenuScreen/MarginContainer/VBoxContainer/StartButton".text = "Continue"
		$"MenuScreenLayer/StartMenuScreen/MarginContainer/VBoxContainer/DeleteButton".disabled = false
	pauseGame()
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		saveProgress()

func pauseGame():
	previousPauseState = get_tree().paused
	if game:
		game.inMenu = true
	get_tree().paused = true
	$MusicLoopPlayer.play()
	
func unpauseGame():
	get_tree().paused = previousPauseState
	game.inMenu = false
	$MusicLoopPlayer.stop()

func quitGame():
	saveProgress()
	get_tree().quit()
	
func restartLevel():
	if game:
		game.queue_free()
	Base.setTimeScale(get_tree(), 1)
	game = gameScene.instance()
	add_child(game)
	game.connect("gameFinished", self, "gameFinished")
	game.inMenu = false
	game.call_deferred("setTutorialProgress", tutorialProgress)

func restartGame():
	saveProgress()
	#warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	get_tree().paused = false


func saveProgress():
	var progressData = {
		"tutorialProgress" : tutorialProgress,
	}
	
	var saveFile = File.new()
	saveFile.open(saveFileName, File.WRITE)
	saveFile.store_line(to_json(progressData))
	saveFile.close()
	
	$"MenuScreenLayer/OptionsScreen".save_options()

func loadProgress():
	var saveFile = File.new()
	if not saveFile.file_exists(saveFileName):
		restartLevel()
		return

	saveFile.open(saveFileName, File.READ)
	var optionsData = parse_json(saveFile.get_line())
	saveFile.close()
	
	if optionsData.has("tutorialProgress"):
		tutorialProgress = optionsData["tutorialProgress"]
	
	#restartLevel()


func _on_MenuScreen_restart_game():
	restartGame()

func _on_MenuScreen_restart_level():
	Base.setTimeScale(get_tree(), 1)
	game.loadLevel()

func _on_StartMenuScreen_quit_game():
	quitGame()

func _on_MenuScreen_quit_game():
	quitGame()

func _on_MenuScreen_pause():
	pauseGame()

func _on_MenuScreen_unpause():
	unpauseGame()

func _on_StartMenuScreen_start_game():
	if tutorialProgress == 0:
		tutorialProgress += 1
		saveProgress()
	restartLevel()
	unpauseGame()

func _on_DeleteScreen_deleteSaveData():
	tutorialProgress = 0
	$"MenuScreenLayer/StartMenuScreen/MarginContainer/VBoxContainer/StartButton".text = "New Game"
	$"MenuScreenLayer/StartMenuScreen/MarginContainer/VBoxContainer/DeleteButton".disabled = true
	saveProgress()
	restartLevel()

const tutorialProgressPerChapter = {
	1: 1,
	2: 4,
	3: 14,
	4: 18
}

func _on_ChapterScreen_selectChapter(chapter):
	tutorialProgress = tutorialProgressPerChapter[chapter]
	saveProgress()
	restartLevel()
	$MenuScreenLayer/StartMenuScreen.go_away()
	unpauseGame()

func gameFinished():
	pauseGame()
	tutorialProgress = 0
	saveProgress()
	$MenuScreenLayer/StartMenuScreen.popup()
	$MenuScreenLayer/EndCreditsScreen.popup()
	
