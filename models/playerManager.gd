extends Node

onready var DB      = load("res://script/plugins/DBconnection.gd").new()
onready var Helper  = preload("res://script/plugins/DBhelper.gd").new()
var local           = preload("res://script/plugins/DBlocal.gd").new()

var player setget set_player, get_player
var setting setget set_setting, get_setting

func _ready():
	set_player(DB.readJSON("pemain"))
	set_setting(DB.readJSON("setting"))

func get_player_data():
	_ready()
	return get_player()

func get_slot():
	var data = get_player_data()
	return data['slot']

func pay(cost):
	var pmoney = get_player_data()["c"]
	if( pmoney < cost):
		return false
	else:
		pmoney -= cost
		pmoney = int(pmoney)
		DB.pushJSON(["c"], [pmoney], "pemain")
		return true

func give_money(amount):
	var pmoney = get_player_data()["c"]
	DB.pushJSON(["c"], [pmoney+amount], "pemain")

func add_slot():
	var slot = get_player_data()["slot"]
	DB.pushJSON(["slot"], [slot+1], "pemain")

func player_change_name():
	_ready()
	var new_name = $window/name.text
	DB.pushJSON(["username"], [new_name], "pemain")
	$window/username.text = new_name + get_player()["uid"]


func get_setting_data():
	_ready()
	return get_setting()

func get_control_type():
	var data = get_setting_data()
	return data['control']
func toggle_control():
	var type = get_control_type()
	DB.pushJSON(["control"], [!type], "setting")

func get_sound_type():
	var data = get_setting_data()
	return data['sound']
func toggle_sound():
	var type = get_sound_type()
	DB.pushJSON(["sound"], [!type], "setting")

func set_setting(args):
	setting = args
func get_setting():
	return setting
func set_player(args):
	player = args
func get_player():
	return player
