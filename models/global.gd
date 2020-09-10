extends Node

var toko = "powerup" setget set_toko, get_toko
var equip = [0,0,0,0] setget set_equip, get_equip
var limit_equip = [0,0,0,0] setget set_lim_equip, get_lim_equip
var jilid = 1 setget set_jilid, get_jilid
var stage = "1" setget set_stage, get_stage
var audio = true setget set_audio, get_audio
var radar_duration = 3 setget set_radar, get_radar
var baju_sekarang = "" setget set_baju, get_baju
var gametime = 60 setget set_gametime, get_gametime
var mode = "tutor_main" setget set_mode, get_mode

var item   = load("res://models/itemManager.gd").new()
var player = load("res://models/playerManager.gd").new()

func _ready():
	if (player.get_player_data()['tutorial']  == true) :
		set_mode('tutor_main')
	else:
		set_mode('')

func init_limit_equip():
	var radar = item.get_item_tier('radar')
	if radar == 0:
		mod_lim_equip(0,0)
	elif radar == 1:
			mod_lim_equip(0,3)
	elif radar == 2:
			mod_lim_equip(0,5)
	else:
			mod_lim_equip(0,7)
	for i in range(1,4):
		var amount = item.owned_item_id(get_equip()[i])
		mod_lim_equip(i, amount)

func set_toko(args):
	toko = args
func get_toko():
	return toko

func set_equip(args):
	equip = args
func get_equip():
	var radar = item.get_item_tier('radar')
	equip[0] = radar
	return equip

func set_lim_equip(args):
	limit_equip = args
func mod_lim_equip(index, value):
	var temp = get_lim_equip()
	temp[index] = value
	set_lim_equip(temp)
func get_lim_equip():
	return limit_equip

func set_jilid(args):
	jilid = args
func get_jilid():
	return jilid

func set_stage(args):
	stage = args
func get_stage():
	return stage

func set_audio(args):
	audio = args
func get_audio():
	return audio

func set_radar(args):
	radar_duration = args
func get_radar():
	return radar_duration

func set_baju(args):
	baju_sekarang = args
func get_baju():
	return baju_sekarang

func init_gametime():
	var warp = item.get_item_tier('timecontrol')
	var time = gametime
	if warp == 0:
		return
	elif warp == 1:
		set_gametime(time+20)
	elif warp == 2:
		set_gametime(time+40)
	elif warp == 3:
		set_gametime(time+60)
	else:
		set_gametime(time+80)
func set_gametime(args):
	gametime = args
func get_gametime():
	init_gametime()
	return gametime

func set_mode(args):
	mode = args
func get_mode():
	return mode
