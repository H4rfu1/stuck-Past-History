extends Node

var toko = "powerup" setget set_toko, get_toko
var equip = [0,0,0,0] setget set_equip, get_equip
var limit_equip = [0,0,0,0] setget set_lim_equip, get_lim_equip
var jilid = 1 setget set_jilid, get_jilid
var stage = "1" setget set_stage, get_stage

var item = load("res://models/itemManager.gd").new()

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
