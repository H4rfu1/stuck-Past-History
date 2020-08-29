extends Control

onready var label = get_node("window/Label")
var message setget set_msg, get_msg
var page setget set_page, get_page

func _ready():
	pass

func set_msg(value):
	message = value
func get_msg():
	return message

func set_page(value):
	page = value

func get_page():
	return page

func create(message: Array):
	set_msg(message)
	set_page(0)
	$".".visible = true
	label.percent_visible = 0
	label.visible_characters = 0
	label.set_bbcode(message[0])

func _on_Timer_timeout():
	label.set_visible_characters(label.visible_characters +1)

func _on_btn_skip_pressed():
	if(label.visible_characters > len(label.text)):
		message = get_msg()
		set_page(get_page()+1)
		if(len(message) == get_page()):
			_on_btn_close_pressed()
		else:
			label.percent_visible = 0
			label.visible_characters = 0
			label.set_bbcode(message[get_page()])
	else:
		label.visible_characters = 9999
	

func _on_btn_close_pressed():
	$".".visible = false
