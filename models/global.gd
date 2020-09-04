extends Node

var toko = "powerup" setget set_toko, get_toko
var equip = [0,2,0,0] setget set_equip, get_equip


func set_toko(args):
	toko = args
func get_toko():
	return toko

func set_equip(args):
	equip = args
func get_equip():
	return equip
