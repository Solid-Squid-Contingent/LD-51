extends Node2D

signal all_text_appeared

onready var label = $TextBox/Label
onready var nameLabel = $TextBox/NameLabel
onready var timer = $ShowTextTimer

var textLengthUpperLimit = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_visible_characters(label.get_total_character_count())

func hide():
	visible = false
	$Music.stop()
	
func show():
	visible = true
	$Music.play()


func set_text(text):
	label.text = text
	label.visible_characters = 0
	timer.start()
	
	textLengthUpperLimit = text.length()

func set_name(name):
	if name.length() == 0:
		nameLabel.bbcode_text = ""
	else:
		nameLabel.bbcode_text = "[b]" + name + ":[/b]"


func text_length():
	if label.get_total_character_count() == 0: # the text length isn't ready yet
		return textLengthUpperLimit
	else:
		return label.get_total_character_count()


func all_text_appeared():
	return label.get_visible_characters() >= text_length()
		

func show_all_text():
	label.set_visible_characters(text_length())
	timer.stop()
	emit_signal("all_text_appeared")

func _on_ShowTextTimer_timeout():
	var pos = label.text.find(' ', label.get_visible_characters() + 1)
	label.set_visible_characters(pos)
	$AppearPlayer.play()
	$AppearPlayer.pitch_scale = rand_range(0.9, 1.1)
	if all_text_appeared():
		timer.stop()
		emit_signal("all_text_appeared")
