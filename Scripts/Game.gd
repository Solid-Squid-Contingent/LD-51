extends Node2D

signal restartGame()

onready var textbox = $"HUD/TextBox"

var dialogProgress = 0
var tutorialProgress = 0
var dialog = []
var inMenu = true

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
	pass

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
