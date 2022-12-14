extends TextureRect

signal button_pressed()
signal back_button_pressed()
signal screenClosed()
signal selectChapter()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("open_options"):
		if visible:
			go_away()

func popup():
	visible = true

func go_away():
	visible = false
	emit_signal("screenClosed")

func selectChapter(chapter):
	go_away()
	emit_signal("button_pressed")
	emit_signal("selectChapter",chapter)	
	

func _on_BackButton_pressed():
	go_away()
	emit_signal("back_button_pressed")

func _on_Chapter1Button_pressed():
	selectChapter(1)

func _on_Chapter2Button_pressed():
	selectChapter(2)

func _on_Chapter3Button_pressed():
	selectChapter(3)

func _on_Chapter4Button_pressed():
	selectChapter(4)

