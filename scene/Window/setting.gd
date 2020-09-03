extends Control

onready var DB = load("res://script/plugins/DBconnection.gd").new()
var local      = preload("res://script/plugins/DBlocal.gd").new()

var sound_state setget set_sound, get_sound
var control_state setget set_control, get_control # True indicate jostick

var player setget set_player, get_player
var setting setget set_setting, get_setting

func _ready():
	set_setting(DB.readJSON("setting"))
	set_player (DB.readJSON("pemain"))
	set_sound(get_setting()['sound'])
	set_control(get_setting()['sound'])
	$window/name.text = get_player()["username"]
	$window/username.text = get_player()["username"] + get_player()["uid"]
	icon_state()

func _on_btn_credit_pressed():
	$dialog_window.create(["Game ini dibuat oleh Kelompok Tapesoft, Universitas Jember \nOur Teams: \nHigh concept: M Amri Zaman \nMain programmer: M Fahrul Hafidz \nArtist & programmer: Hartawan Bahari M "])

func _on_lisensi_pressed():
	$dialog_window.create(["???\nComing soon"])

func _on_btn_sound_pressed():
	var bol = get_sound()
	set_sound(!bol)
	icon_state()
func _on_btn_control_pressed():
	var bol = get_control()
	set_control(!bol)
	icon_state()

func icon_state():
	var sound_btn = $window/contain/btn_group/btn_sound
	var control_btn = $window/contain/btn_group/btn_control
	print("sound",get_sound(), "controll", get_control())
	if(get_sound()):
		sound_btn.texture_normal  = load("res://assets/UI/button/sound.png")
		sound_btn.texture_pressed = load("res://assets/UI/button/sound_press.png")
		sound_btn.texture_hover   = load("res://assets/UI/button/sound_press.png")
	else:
		sound_btn.texture_normal  = load("res://assets/UI/button/sound_mute.png")
		sound_btn.texture_pressed = load("res://assets/UI/button/sound_mute_press.png")
		sound_btn.texture_hover   = load("res://assets/UI/button/sound_mute_press.png")
	if(get_control()):
		control_btn.texture_normal  = load("res://assets/UI/button/arrow.png")
		control_btn.texture_pressed = load("res://assets/UI/button/arrow_press.png")
		control_btn.texture_hover   = load("res://assets/UI/button/arrow_press.png")
	else:
		control_btn.texture_normal  = load("res://assets/UI/button/joystick.png")
		control_btn.texture_pressed = load("res://assets/UI/button/joystick_press.png")
		control_btn.texture_hover   = load("res://assets/UI/button/joystick_press.png")

func _on_btn_close_pressed():
	$".".visible = false


func _on_change_name():
	var new_name = $window/name.text
	DB.pushJSON(["username"], [new_name], "pemain")
	$window/username.text = new_name + get_player()["uid"]

func set_setting(args):
	setting = args
func get_setting():
	return setting
func set_player(args):
	player = args
func get_player():
	return player

func set_sound(args):
	sound_state = args
	DB.pushJSON(["sound"], [args], "setting")
func get_sound():
	return sound_state
func set_control(args):
	control_state = args
	DB.pushJSON(["control"], [args], "setting")
func get_control():
	return control_state
